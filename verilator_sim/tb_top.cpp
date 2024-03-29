// Verilator Example
#include <stdlib.h>
#include <iostream>
#include <cstdlib>
#include <memory>
#include <set>
#include <deque>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <verilated_cov.h>
#include "Vtop.h"
#include "Vtop_top.h"   //to get parameter values, after they've been made visible in SV
#include "Vtop___024root.h"

#define MAX_SIM_TIME 300
#define VERIF_START_TIME 7
vluint64_t sim_time = 0;
vluint64_t posedge_cnt = 0;

// input interface transaction item class
class InTx {
    private:
    public:
        unsigned int en;
};


// output interface transaction item class
class OutTx {
    public:
        unsigned int is_fizz;
        unsigned int is_buzz;
        unsigned int number;
};

//in domain Coverage
// class InCoverage{
//     private:
//         std::set <std::tuple <unsigned int, unsigned int> > in_cvg;
    
//     public:
//         void write_coverage(InTx *tx){
//             std::tuple<unsigned int,unsigned int> t;
//             t = std::make_tuple(tx->A,tx->B);
//             in_cvg.insert(t);
//         }

//         bool is_covered(unsigned int A, unsigned int B){
//             std::tuple<unsigned int,unsigned int> t;
//             t = std::make_tuple(A,B);            
//             return in_cvg.find(t) == in_cvg.end();
//         }
// };

// out domain Coverage
class OutCoverage {
    private:
        std::set <unsigned int> coverage;
        int cvg_size =0;

    public:
        void write_coverage(OutTx* tx){
            coverage.insert(tx->number);
            cvg_size++;
            // std::cout << "num is :" << tx->number << "fizz is :" << tx->is_fizz << "buzz is :" << tx->is_buzz << std::endl;
        }

        bool is_full_coverage(){
            return cvg_size == 2*Vtop_top::g_length;
            // return coverage.size() == Vtop_top::g_length-1;
        }
};


// ALU scoreboard
class Scb {
    private:
        // std::deque<InTx*> in_q;
        
    public:
        // Input interface monitor port
        // void writeIn(InTx *tx){
        //     // Push the received transaction item into a queue for later
        //     in_q.push_back(tx);
        // }

        // Output interface monitor port
        void writeOut(OutTx* tx){
            // We should never get any data from the output interface
            // before an input gets driven to the input interface
            // if(in_q.empty()){
            //     std::cout <<"Fatal Error in AluScb: empty InTx queue" << std::endl;
            //     exit(1);
            // }

            // Grab the transaction item from the front of the input item queue
            // InTx* in;
            // in = in_q.front();
            // in_q.pop_front();

            if(tx->number !=0 && tx->number % 3 == 0 && tx->is_fizz != 1){
                std::cout << "Test Failure!" << std::endl;
                std::cout << "number is : " << tx->number << ", fizz is :" << tx->is_fizz << std::endl;
            } else if(tx->number !=0 && tx->number % 5 == 0 && tx->is_buzz != 1){
                std::cout << "Test Failure!" << std::endl;
                std::cout << "number is : " << tx->number << ", buzz is :" << tx->is_buzz << std::endl;
            }

            // As the transaction items were allocated on the heap, it's important
            // to free the memory after they have been used
            // delete in;    //input monitor transaction
            delete tx;    //output monitor transaction
        }
};

// interface driver
class InDrv {
    private:
        // Vadder *dut;
        std::shared_ptr<Vtop> dut;
    public:
        InDrv(std::shared_ptr<Vtop> dut){
            this->dut = dut;
        }

        void drive(InTx *tx){
            // we always start with in_valid set to 0, and set it to
            // 1 later only if necessary
            // dut->i_valid = 0;

            // Don't drive anything if a transaction item doesn't exist
            if(tx != NULL){
                // dut->i_valid = 1;
                // dut->i_A = tx->A;
                // dut->i_B = tx->B;
                dut->i_en = tx->en;
                // Release the memory by deleting the tx item
                // after it has been consumed
                delete tx;
            }
        }
};

// input interface monitor
// class InMon {
//     private:
//         // Vadder *dut;
//         std::shared_ptr<Vadder> dut;
//         // Scb *scb;
//         std::shared_ptr<Scb>  scb;
//         // InCoverage *cvg;
//         std::shared_ptr<InCoverage> cvg;
//     public:
//         InMon(std::shared_ptr<Vadder> dut, std::shared_ptr<Scb>  scb, std::shared_ptr<InCoverage> cvg){
//             this->dut = dut;
//             this->scb = scb;
//             this->cvg = cvg;
//         }

//         void monitor(){
//             if(dut->i_valid == 1){
//                 InTx *tx = new InTx();
//                 tx->A = dut->i_A;
//                 tx->B = dut->i_B;
//                 // then pass the transaction item to the scoreboard
//                 scb->writeIn(tx);
//                 cvg->write_coverage(tx);
//             }
//         }
// };

// ALU output interface monitor
class OutMon {
    private:
        // Vadder *dut;
        std::shared_ptr<Vtop> dut;
        // Scb *scb;
        std::shared_ptr<Scb> scb;
        // OutCoverage *cvg;
        std::shared_ptr<OutCoverage> cvg;
    public:
        OutMon(std::shared_ptr<Vtop> dut, std::shared_ptr<Scb> scb,std::shared_ptr<OutCoverage> cvg){
            this->dut = dut;
            this->scb = scb;
            this->cvg = cvg;
        }

        void monitor(){
            // if(dut->rootp->fizzbuzz->start == 1) {
                OutTx *tx = new OutTx();    
                tx->is_fizz = dut->o_is_fizz;
                tx->is_buzz = dut->o_is_buzz;
                tx->number = dut->o_number;

                // then pass the transaction item to the scoreboard
                scb->writeOut(tx);
                cvg->write_coverage(tx);
            // }
            // }
        }
};

//sequence (transaction generator)
// coverage-driven random transaction generator
// This will allocate memory for an InTx
// transaction item, randomise the data, until it gets
// input values that have yet to be covered and
// return a pointer to the transaction item object
class Sequence{
    private:
        InTx* in;
        // InCoverage *cvg;
        // std::shared_ptr<InCoverage> cvg;
    public:
        // Sequence(std::shared_ptr<InCoverage> cvg){
        //     this->cvg = cvg;
        // }

        InTx* genTx(){
            in = new InTx();
            // std::shared_ptr<InTx> in(new InTx());
            in->en = 1;
            return in;
            // if(rand()%5 == 0){
            //     // if(rand()%2 == 0){
            //     in->en = rand() % 2;
            //     // in->B = rand() % 2;

            //         // while(cvg->is_covered(in->A,in->B) == false){
            //         //     in->A = rand() % (1 << Vtop_top::g_data_width);  
            //         //     in->B = rand() % (1 << Vtop_top::g_data_width); 
            //         // }
            //     // }
            //     return in;
            // } else {
            //     return NULL;
            // }
        }
};


void dut_reset (std::shared_ptr<Vtop> dut, vluint64_t &sim_time){
    dut->i_rst = 0;
    if(sim_time >= 3 && sim_time < 6){
        dut->i_rst = 1;
    }
}

int main(int argc, char** argv, char** env) {
    srand (time(NULL));
    Verilated::commandArgs(argc, argv);
    // Vtop *dut = new Vtop;
    std::shared_ptr<Vtop> dut(new Vtop);

    Verilated::traceEverOn(true);
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    InTx   *tx;

    // Here we create the driver, scoreboard, input and output monitor and coverage blocks
    std::unique_ptr<InDrv> drv(new InDrv(dut));
    std::shared_ptr<Scb> scb(new Scb());
    // std::shared_ptr<InCoverage> inCoverage(new InCoverage());
    std::shared_ptr<OutCoverage> outCoverage(new OutCoverage());
    // std::unique_ptr<InMon> inMon(new InMon(dut,scb,inCoverage));
    std::unique_ptr<OutMon> outMon(new OutMon(dut,scb,outCoverage));
    std::unique_ptr<Sequence> sequence(new Sequence());

    // while(sim_time < MAX_SIM_TIME){
    while (outCoverage->is_full_coverage() == false) {
        // random reset 
        // 0-> all 0s
        // 1 -> all 1s
        // 2 -> all random
        Verilated::randReset(2); 
        dut_reset(dut, sim_time);
        dut->i_clk ^= 1;
        dut->eval();

        // Do all the driving/monitoring on a positive edge
        if (dut->i_clk == 1){

            if (sim_time >= VERIF_START_TIME) {
                // Generate a randomised transaction item 
                // tx = rndInTx(inCoverage);
                tx = sequence->genTx();

                // Pass the generated transaction item in the driver
                //to convert it to pin wiggles
                //operation similar to than of a connection between
                //a sequencer and a driver in a UVM tb
                drv->drive(tx);

                // Monitor the input interface
                // also writes recovered transaction to
                // input coverage and scoreboard
                // inMon->monitor();

                // Monitor the output interface
                // also writes recovered result (out transaction) to
                // output coverage and scoreboard 
                outMon->monitor();
            }
        }
        // end of positive edge processing

        m_trace->dump(sim_time);
        sim_time++;
    }

    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage.dat");
    m_trace->close();  
    exit(EXIT_SUCCESS);
}
