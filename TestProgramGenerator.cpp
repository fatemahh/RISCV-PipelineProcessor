#include <iostream>
using namespace std;

#include <string>
#include <vector>
#include <cstdlib>
#include <ctime>

// RISC-V registers
std::vector<std::string> registers = { "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9", "x10", "x11", "x12", "x13", "x14", "x15", "x16", "x17", "x18", "x19", "x20", "x21", "x22", "x23", "x24", "x25", "x26", "x27", "x28", "x29", "x30", "x31" };

// RISC-V instruction set
std::vector<std::string> instructions = { "add", "sub", "and", "or", "xor", "sll", "srl", "slt", "sltu", "sra",
                                        "addi", "andi", "ori", "xori", "slli", "srli", "slti", "sltiu", "srai",
                                        "lui", "auipc",
                                        "lw", "sw", "lb", "sb", "lh", "sh", "lbu", "lhu",
                                        "jal", "jalr",
                                        "beq", "bne", "blt", "bge", "bltu", "bgeu",
                                        "ebreak", "ecall", "fence",
};

std::string generate_random_register() {
    return registers[rand() % registers.size()];
}

std::string generate_random_instruction() {
    return instructions[rand() % instructions.size()];
}

int generate_random_immediate() {
    return rand() % 0xFFFFF;
}

std::vector<std::string> generate_test_program(int num_instructions) {
    std::vector<std::string> program;

    for (int i = 0; i < num_instructions; ++i) {
        std::string instruction = generate_random_instruction();

        if (instruction == "jal") {
            std::string rd = generate_random_register();
            int imm = generate_random_immediate();
            program.push_back(instruction + " " + rd + ", " + std::to_string(imm));
        }
        else if (instruction == "lui" || instruction == "auipc") {
            std::string rd = generate_random_register();
            int imm = generate_random_immediate();
            program.push_back(instruction + " " + rd + ", " + std::to_string(imm));
        }
        else if (instruction == "jalr" || instruction == "lw" || instruction == "sw" || instruction == "lb" || instruction == "sb" || instruction == "lh" || instruction == "sh" || instruction == "lbu" || instruction == "lhu") {
            int imm = generate_random_immediate() * 4;
            std::string rd = generate_random_register();
            std::string rs = generate_random_register();
            program.push_back(instruction + " " + rd + ", " + std::to_string(imm) + "(" + rd + ")");
        }
        else if (instruction == "addi" || instruction == "andi" || instruction == "ori" || instruction == "xori" || instruction == "slli" || instruction == "srli" || instruction == "slti" || instruction == "sltiu" || instruction == "srai") {
            int imm = generate_random_immediate();
            std::string rd = generate_random_register();
            std::string rs = generate_random_register();
            program.push_back(instruction + " " + rd + ", " + rs + ", " + std::to_string(imm));
        }
        else if (instruction == "ebreak" || instruction == "fence" || instruction == "ecall") {
            program.push_back(instruction);
        }
        else {
            std::string rd = generate_random_register();
            std::string rs1 = generate_random_register();
            std::string rs2 = generate_random_register();
            program.push_back(instruction + " " + rd + ", " + rs1 + ", " + rs2);
        }
    }

    return program;
}

int main() {

    // Generate a test program with 10 instructions
    std::vector<std::string> test_program = generate_test_program(10);

    // Print the generated test program
    for (const auto& instruction : test_program) {
        std::cout << instruction << std::endl;
    }

    return 0;
}
