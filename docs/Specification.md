## Requirements Specification


### 1. SCOPE

1. **Scope**

   This document establishes the requirements for an Intellectual Property (IP) that provides a FizzBuzz function.
1. **Purpose**
 
   These requirements shall apply to a FizzBuzz core with a simple interface for inclusion as a component.
1. **Classification**
    
   This document defines the requirements for a hardware design.


### 2. DEFINITIONS

1. **FizzBuzz**

   FizzBuzz is a game to practise division, where player count numbers and exclain fizz when the current number is divisible by 3, buzz if it is divisible by 5 and fizzbuzz if it is divisible by both.
   

### 3. APPLICABLE DOCUMENTS 

1. **Government Documents**

   None
1. **Non-government Documents**

   None


### 4. ARCHITECTURAL OVERVIEW

1. **Introduction**

   The FizzBuzz component shall represent a design written in an HDL (VHDL and/or SystemVerilog) that can easily be incorporateed into a larger design. The core shall include the following features : 
     1. Adherence to FizzBuzz game rules.

No particular interface will be used in the initial phase of this core for communicating with the processor/controller.

1. **System Application**
   
    The FizzBuzz can be applied to a variety of system configurations. Most probably though, it will be useful as a standalone core for its own functionality.

### 5. PHYSICAL LAYER

1. en, start the game
5. is_fizz, current number divisible by 3
6. is_buzz, current number divisible by 5
8. o_number, current number 
7. clk, system clock
8. rst, system reset, synchronous active high

### 6. PROTOCOL LAYER

Does not apply. 

### 7. ROBUSTNESS

Does not apply.

### 8. HARDWARE AND SOFTWARE

1. **Parameterization**

   The fizzbuzz shall provide for the following parameters used for the definition of the implemented hardware during hardware build:

   | Param. Name | Description |
   | :------: | :------: |
   | length | maximum number to count up to |

 

1. **CPU interface**

   No particular CPU interface.


### 9. PERFORMANCE

1. **Frequency**
1. **Power Dissipation**
1. **Environmental**
 
   Does not apply.
1. **Technology**

   The design shall be adaptable to any technology because the design shall be portable and defined in an HDL.

### 10. TESTABILITY
None required.

### 11. MECHANICAL
Does not apply.
