五段流水示意图：

```
|  IF1  |  ID1  |  EXE1 |  MEM1 |  WB1  |
        |  IF2  |  ID2  |  EXE2 |  MEM2 |  WB2  |
                |  IF3  |  ID3  |  EXE3 |  MEM3 |  WB3  |
                        |  IF4  |  ID4  |  EXE4 |  MEM4 |  WB4  |
                                |  IF5  |  ID5  |  EXE5 |  MEM5 |  WB5  |
```
		


现在看来冲突有这么几种：

## 数据冲突（写后读）
指令B想用它前一两条指令A算出的结果。具体地，数据冲突的可能情况如下：


| 数据产生阶段 | 数据写回阶段 | 数据读取阶段 | 读取时数据位于         | 指令A | 指令B |
| ------------ | ------------ | ------------ | ---------------------- | ----- | ----- |
| ID           | WB           | ID           | EXE(1), MEM(2), WB(3)  | MOVE  | MOVE  |
| EXE          | WB           | ID           | EXE(1), MEM(2), WB(3)  | ADDU  | MOVE  |
| MEM          | WB           | ID           | NOTEXIST(1), MEM(2), WB(3) | LW    | MOVE  |
| ID           | MEM          | IF           | ID(1), EXE(2), MEM(3)    | SW | (ANY) | 

这种情况，产生结果的指令如果领先它2条，那么该有的结果都有了，可以直接forward；如果只领先1条，那么如果是普通运算指令，ALU已经结束了结果也有了，可以直接forward; 但是如果是从内存里读数据的话，结果还得等一周期，所以只能暂停一波。forward unit只处理这里说的两种情况。

在检测到NOTEXIST后需要插入气泡。此冲突应当在A的EXE阶段（即B的ID阶段）检测，检测到后保持IF/ID寄存器，将ID/EXE寄存器置零。

## 结构冲突

### RAM

同时访问同一块RAM是不可以的。

检测流水线中指令地址，若有与写入地址位于同一RAM则将冲突的指令及之后全部清除。

重大喜讯：将跳转指令置于延迟槽中在MIPS指令中是未定义行为！！！

考虑指令B=4，A=1，且MEM1与IF4访问同一RAM。有下面几种情形：
* EXE2阶段有跳转，且跳转预测成功。清除指令4，暂停累加。
* EXE2阶段有跳转，且跳转预测失败。这种情形可以不做处理，直接按照branch的处理，将B指令清除（由于EXE3不可跳转，这样不会造成问题）。
* EXE2阶段无跳转。这种情况有些麻烦。若EXE3中有跳转，则需要寄存跳转地址，直至能够正确读入指令。

## Bubble & Stall Control Unit 设计

### 端口列表

输入：
* exeWbEN: ID/EXE是否写回信号
* exeDstSrc(4): ID/EXE目标写回地址
* exeRamRead: ID/EXE中RAM是否读
* idRegSrcA(4): ID阶段中寄存器地址A（control的输出信号）
* idRegSrcB(4): ID阶段中寄存器地址B（control的输出信号）
* exeBranchJudge: EXE阶段是否跳转
* exeBranchTo(16): EXE阶段跳转地址
* ifAddr(16): IF阶段传入的指令地址
* ramConflict: 是否存在同时读写统一块RAM的冲突

输出：
* pcPause: 下一时钟周期时钟是否更新
* idKeep: IF/ID寄存器保持
* idClear: IF/ID寄存器置零
* exeClear: ID/EXE寄存器置零
* pcInc: PC是否自增（否则接受跳转的地址）
* setPC: 是否强行设置下一周期PC
* setPCVal(16)：强行设置下一周期PC的值


