# 基於RISC-V Core的FPGA 1A2B遊戲機 
#### 開發板：Basys3
#### Vivado版本：2025.2
#### RISC-V toolchain：Ripes built-in compiler(Ripes v2.2.6)

#### 專案目錄
```text
├── Bitstreams
│   └── top_soc.bit
├── Code
│   ├── Assembly.txt
│   └── MachineCode.txt
├── Constraints
│   └── basys3_pins.xdc
├── Verilog
│   ├── Adder.v
│   ├── ALUCtrl.v
│   ├── ALU.v
│   ├── BranchComp.v
│   ├── Control.v
│   ├── DataMemory.v
│   ├── debounce_vector.v
│   ├── ImmGen.v
│   ├── InstructionMemory.v
│   ├── Mux2to1.v
│   ├── Mux3to1.v
│   ├── Mux4to1.v
│   ├── PC.v
│   ├── Register.v
│   ├── seven_seg_controller.v
│   ├── SingleCycleCPU.v
│   └── top_soc.v
├── s1120418_final_project_report.pdf
└── README.md
```

#### 程式修改
將修改好的RISC-V組合語言轉成機器語言，並以一行指令一行的格式(一行32位元)儲存進MachineCode.txt。
#### bitstream產生
建立Vivado專案，將所有Verilog與xdc匯入，將MachineCode.txt移至InstructionMemory.v相同目錄內，依序進行Synthesis->Implementation->Bitstream Generation。
#### 燒錄到FPGA開發板
電腦連接Basys3開發板，開啟Vivado的Hardware Manager，將Bitstream Generation產生的top_soc.bit檔Program Device進Basys3開發板中。
#### 操作說明
最左邊的開關(sw15)是機器開關，打開會進入遊戲畫面，按下中鍵開始遊戲，使用左右鍵切換編輯目標，上下鍵編輯，中鍵送出猜測。
最右邊的開關(sw0)打開能顯示猜測次數。
右邊第二個開關(sw1)打開能進入歷史查詢模式，按上/下鍵可自由翻閱歷史猜測的紀錄。在任意歷史紀錄畫面上按下中鍵，即可即時切換顯示該次猜測的「幾A幾B判定結果」。
注：同時打開sw0和sw1時不會進入二者。

同時打開最右邊四個開關(sw0~3)會進入除錯模式，直接顯示謎底。

💡 **提示**：關於本系統更詳細內容，請參閱本專案內隨附之[s1120418_final_project_report.pdf](./s1120418_final_project_report.pdf)完整專題結案報告。

#### 外部來源與授權說明
處理器核心來源：本專題之單週期（Single-Cycle）微處理器核心架構，其基本暫存器與資料通路係繼承並參考自國立陽明交通大學（NYCU）CO2026 之 Lab3 開源專案[nycu-caslab/CO2026/Lab3](https://github.com/nycu-caslab/CO2026/tree/main/Lab3)。