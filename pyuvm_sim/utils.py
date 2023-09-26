
from cocotb.triggers import Timer,RisingEdge,ClockCycles
from cocotb.queue import QueueEmpty, Queue
from cocotb.result import TestFailure
import cocotb
import enum
import random
from cocotb_coverage import crv 
from cocotb_coverage.coverage import CoverCross,CoverPoint,coverage_db,CoverCheck
from pyuvm import utility_classes



class FizzBuzzBfm(metaclass=utility_classes.Singleton):
    def __init__(self):
        self.dut = cocotb.top
        self.driver_queue = Queue(maxsize=1)
        self.data_mon_queue = Queue(maxsize=0)
        self.result_mon_queue = Queue(maxsize=0)

    async def send_data(self, en):
        await self.driver_queue.put(en)

    async def get_data(self):
        en = await self.data_mon_queue.get()
        return en

    async def get_result(self):
        result = await self.result_mon_queue.get()
        return result

    async def reset(self):
        await RisingEdge(self.dut.i_clk)
        self.dut.i_rst.value = 1
        self.dut.i_en.value = 0
        await ClockCycles(self.dut.i_clk,5)
        self.dut.i_rst.value = 0
        await RisingEdge(self.dut.i_clk)


    async def driver_bfm(self):
        self.dut.i_en.value = 0
        while True:
            await RisingEdge(self.dut.i_clk)
            try:
                en = self.driver_queue.get_nowait()
                self.dut.i_en.value = en
            except QueueEmpty:
                pass

    async def data_mon_bfm(self):
        while True:
            await RisingEdge(self.dut.i_clk)
            en = self.dut.i_en.value
            self.data_mon_queue.put_nowait(en)

    async def result_mon_bfm(self):
        while True:
            await RisingEdge(self.dut.i_clk)
            if(self.dut.i_rst.value ==0):
                self.result_mon_queue.put_nowait((self.dut.o_number.value,self.dut.o_is_fizz.value,self.dut.o_is_buzz.value))


    def start_bfm(self):
        cocotb.start_soon(self.driver_bfm())
        cocotb.start_soon(self.data_mon_bfm())
        cocotb.start_soon(self.result_mon_bfm())


class AssertionsCheck(metaclass=utility_classes.Singleton):
    def __init__(self):
        self.dut = cocotb.top
        self.assertion1 = Assertion_fizzbuzz()
        # self.assertion2 = Assertion_div_by_5()
  
    def start_assertions(self):
        cocotb.start_soon(self.assertion1.assertion_mon_div_by_3_5())


class Assertion_fizzbuzz(metaclass=utility_classes.Singleton):
    def __init__(self):
        self.dut = cocotb.top
        # for: o_number % 3 == 0 |-> o_fizz
        # for: o_number % 5 == 0 |-> o_buzz

    # assert property (@(posedge i_clk) o_number % 3 == 0 |-> o_fizz);
    @CoverCheck(
        "assertion.o_number % 3 == 0 |-> o_fizz",
        f_fail = lambda x : x.o_is_fizz == 0,
        f_pass = lambda x : True
    )
    def test_div_by_3(self,dut):
        pass

    # assert property (@(posedge i_clk) o_number % 3 == 0 |-> o_fizz);
    @CoverCheck(
        "assertion.o_number % 5 == 0 |-> o_buzz",
        f_fail = lambda x : x.o_is_buzz == 0,
        f_pass = lambda x : True
    )
    def test_div_by_5(self,dut):
        pass

    def assert_callback(self):
        raise TestFailure("Assertion failed!")

    async def assertion_mon_div_by_3_5(self):
        while True:
            if(self.dut.o_number.value !=0 and  self.dut.o_number.value % 3 == 0 and self.dut.o_number.value % 5 !=0):
                self.test_div_by_3(self.dut)
                coverage_db["assertion.o_number % 3 == 0 |-> o_fizz"].add_bins_callback(self.assert_callback, "FAIL")
            elif(self.dut.o_number.value !=0 and  self.dut.o_number.value % 3 != 0 and self.dut.o_number.value % 5 ==0):
                self.test_div_by_5(self.dut)
                coverage_db["assertion.o_number % 5 == 0 |-> o_buzz"].add_bins_callback(self.assert_callback, "FAIL")
            elif(self.dut.o_number.value !=0 and  self.dut.o_number.value % 3 == 0 and self.dut.o_number.value % 5 ==0):
                self.test_div_by_3(self.dut)
                coverage_db["assertion.o_number % 3 == 0 |-> o_fizz"].add_bins_callback(self.assert_callback, "FAIL")
                self.test_div_by_5(self.dut)
                coverage_db["assertion.o_number % 5 == 0 |-> o_buzz"].add_bins_callback(self.assert_callback, "FAIL")

            await RisingEdge(self.dut.i_clk)

