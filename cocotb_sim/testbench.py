# Simple test for a fizzbuzz module
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer,RisingEdge,ClockCycles
from cocotb.result import TestFailure
import random
from cocotb_coverage.coverage import CoverCross,CoverPoint,coverage_db,CoverCheck

covered_number = []
g_length = int(cocotb.top.g_length)

div_by_3 = 0
div_by_5 = 0
for i in range(1,g_length):		#count how many times fizz/buzz should be asserted
	if(i%3 ==0):
		div_by_3+=1
	if(i%5 ==0):
		div_by_5+=1

#Callback functions to capture the bin content showing
#how many times dut.o_is_fizz / dut.o_is_buzz has been raised
fizz_count= 0
buzz_count= 0
def notify_fizz():
	global fizz_count
	fizz_count +=1

def notify_buzz():
	global buzz_count
	buzz_count +=1

def assert_callback():
	raise TestFailure("Assertion failed!")


#at_least = value is superfluous, just shows how you can determine the amount of times that
#a bin must be hit to considered covered
@CoverPoint("top.o_number",xf = lambda x : x.o_number.value, bins = list(range(g_length)), at_least=1)
@CoverPoint("top.is_fizz",xf = lambda x : x.o_is_fizz.value == 1,bins = [True,False],at_least=1)
@CoverPoint("top.is_buzz",xf = lambda x : x.o_is_buzz.value == 1,bins = [True,False],at_least=1)
# CoverCheck can be used as a RTL language agnostic solution for embedding either
# immediate or concurrent assertions in simulation.
# most free simmulators dont support concurrent assertions (GHDL,icarus verilog)
# CoverCheck can be used to provide this functionality when using such simulators. 
@CoverCheck(
	"assertion.example",
	f_fail = lambda x : (x.o_number.value != 0) and (x.o_number.value %3 ==0) and (x.o_is_fizz.value ==0),
	f_pass = lambda x : True
)
def number_cover(dut):
	covered_number.append(dut.o_number.value)

async def reset(dut,cycles=1):
	dut.i_rst.value = 1
	await ClockCycles(dut.i_clk,cycles)
	dut.i_rst.value = 0
	await RisingEdge(dut.i_clk)
	dut._log.info("the core was reset")

@cocotb.test()
async def test_fizzbuzz(dut):
	"""Check results and coverage for the length of fizzbuzz"""

	cocotb.start_soon(Clock(dut.i_clk, 10, units="ns").start())
	await reset(dut,5)	
	
	dut.i_en.value = 1

	for i in range(g_length):
		await RisingEdge(dut.i_clk)

		coverage_db["top.is_fizz"].add_bins_callback(notify_fizz, True)
		coverage_db["top.is_buzz"].add_bins_callback(notify_buzz, True)
		coverage_db["assertion.example"].add_bins_callback(assert_callback, "FAIL")
		
		number_cover(dut)
		assert not ((dut.o_number !=0) and ((dut.o_number.value %3 == 0 and dut.o_is_fizz.value != 1) \
		or (dut.o_number.value % 5 ==0 and dut.o_is_buzz.value !=1))) , \
		"Randomised test failed with: fizz :%s  buzz:%s  number:%s" \
		%(dut.o_is_fizz.value, dut.o_is_buzz.value, dut.o_number.value)

	coverage_db.report_coverage(cocotb.log.info,bins=True)
	coverage_db.export_to_xml(filename="coverage.xml")

	#Assert that the number of fizz/buzz raises is the correct given the length
	assert not (div_by_3 != fizz_count),\
	"Incorrect number of fizz assertions"
	assert not (div_by_5 != buzz_count),\
	"Incorrect number of buzz assertions"
