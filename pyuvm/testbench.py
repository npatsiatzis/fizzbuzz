from cocotb.triggers import Timer,ClockCycles,Join,First,Event,Lock
from cocotb.clock import Clock
from pyuvm import *
import random
import cocotb
import pyuvm
from utils import FizzBuzzBfm



g_length = int(cocotb.top.g_length)
covered_values = []
full = False

event = Event(name = 'full')
lock = Lock()

# Sequence classes
class SeqItem(uvm_sequence_item):

    def __init__(self, name, en):
        super().__init__(name)
        self.en = en

    def randomize_operands(self):

        self.en = 1

    def randomize(self):
        self.randomize_operands()

    def __eq__(self, other):
        same = self.en == other.en
        return same

class RandomSeq(uvm_sequence):
    async def body(self):
        data_tr = SeqItem("data_tr",1)
        await self.start_item(data_tr)
        data_tr.randomize_operands()
        await self.finish_item(data_tr)

class TestAllSeq(uvm_sequence):

    async def body(self):
        seqr = ConfigDB().get(None, "", "SEQR")
        random = RandomSeq("random")
        await random.start(seqr)

class Driver(uvm_driver):
    def build_phase(self):
        self.ap = uvm_analysis_port("ap", self)

    def start_of_simulation_phase(self):
        self.bfm = FizzBuzzBfm()

    async def launch_tb(self):
        cocotb.start_soon(Clock(self.bfm.dut.i_clk, 10, units="ns").start())
        await self.bfm.reset()
        self.bfm.start_bfm()

    async def run_phase(self):
        await self.launch_tb()
        while True:
            data = await self.seq_item_port.get_next_item()
            await self.bfm.send_data(data.en)
            result = await self.bfm.get_result()
            self.ap.write(result)
            data.result = result
            self.seq_item_port.item_done()


class Coverage(uvm_subscriber):

    def end_of_elaboration_phase(self):
        self.cvg = set()

    def write(self, result):
        (o_number, is_fizz, is_buzz) = result
        self.cvg.add(int(o_number))

    def report_phase(self):
        try:
            disable_errors = ConfigDB().get(
                self, "", "DISABLE_COVERAGE_ERRORS")
        except UVMConfigItemNotFound:
            disable_errors = False
        if not disable_errors:
            if g_length - len(self.cvg) > 0:
                self.logger.error(
                    f"Functional coverage error. Missed: {set([i for i in range(g_length)])-self.cvg}")   
                assert False

            else:
                self.logger.info("Covered all input space")
                full = True
                event.set()
                assert True


class Scoreboard(uvm_component):

    def build_phase(self):
        self.data_fifo = uvm_tlm_analysis_fifo("data_fifo", self)
        self.result_fifo = uvm_tlm_analysis_fifo("result_fifo", self)
        self.data_get_port = uvm_get_port("data_get_port", self)
        self.result_get_port = uvm_get_port("result_get_port", self)
        self.data_export = self.data_fifo.analysis_export
        self.result_export = self.result_fifo.analysis_export

    def connect_phase(self):
        self.data_get_port.connect(self.data_fifo.get_export)
        self.result_get_port.connect(self.result_fifo.get_export)

    def check_phase(self):
        passed = True
        predicted_result = 0
        try:
            self.errors = ConfigDB().get(self, "", "CREATE_ERRORS")
        except UVMConfigItemNotFound:
            self.errors = False
        while self.result_get_port.can_get():
            _, actual_result = self.result_get_port.try_get()
            data_success, data = self.data_get_port.try_get()
            if not data_success:
                self.logger.critical(f"result {actual_result} had no command")
            else:
                if predicted_result == int(actual_result[0]):
                    
                    self.logger.info("PASSED:")
                else:
                    self.logger.error("FAILED: actual = {}, expected {}"\
                        .format(int(actual_result[0]),predicted_result))

                    passed = False
                predicted_result += 1
        assert passed


class Monitor(uvm_component):
    def __init__(self, name, parent, method_name):
        super().__init__(name, parent)
        self.method_name = method_name

    def build_phase(self):
        self.ap = uvm_analysis_port("ap", self)
        self.bfm = FizzBuzzBfm()
        self.get_method = getattr(self.bfm, self.method_name)

    async def run_phase(self):
        while True:
            datum = await self.get_method()
            self.logger.debug(f"MONITORED {datum}")
            self.ap.write(datum)


class Env(uvm_env):

    def build_phase(self):
        self.seqr = uvm_sequencer("seqr", self)
        ConfigDB().set(None, "*", "SEQR", self.seqr)
        self.driver = Driver.create("driver", self)
        self.data_mon = Monitor("data_mon", self, "get_data")
        self.result_mon = Monitor("result_mon",self,"get_result")
        self.coverage = Coverage("coverage", self)
        self.scoreboard = Scoreboard("scoreboard", self)

    def connect_phase(self):
        self.driver.seq_item_port.connect(self.seqr.seq_item_export)
        self.data_mon.ap.connect(self.scoreboard.data_export)
        self.result_mon.ap.connect(self.coverage.analysis_export)
        # self.data_mon.ap.connect(self.coverage.analysis_export)
        self.driver.ap.connect(self.scoreboard.result_export)


@pyuvm.test()
class Test(uvm_test):
    """Test fizzbuzz with random values"""

    def build_phase(self):
        self.env = Env("env", self)

    def end_of_elaboration_phase(self):
        self.test_all = TestAllSeq.create("test_all")

    async def run_phase(self):
        self.raise_objection()
        await self.test_all.start()
        await Timer(12000,units = 'ns') 
        self.drop_objection()
