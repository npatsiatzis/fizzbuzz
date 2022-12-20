
from cocotb.triggers import Timer,RisingEdge,ClockCycles
from cocotb.queue import QueueEmpty, Queue
import cocotb
import enum
import random
from cocotb_coverage import crv 
from cocotb_coverage.coverage import CoverCross,CoverPoint,coverage_db
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
            self.result_mon_queue.put_nowait((self.dut.o_number.value,self.dut.o_is_fizz.value,self.dut.o_is_buzz.value))


    def start_bfm(self):
        cocotb.start_soon(self.driver_bfm())
        cocotb.start_soon(self.data_mon_bfm())
        cocotb.start_soon(self.result_mon_bfm())