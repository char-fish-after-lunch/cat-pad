CATPAD支持**精确中断处理**。

## 中断检测
### 同步中断

由于同步中断可能发生在流水线的任何一个阶段（暂时假设WB不会产生中断），而精确处理要求符合序列模型（即对处理器用户来说流水线透明，指令似乎仍然是顺序执行的），中断信号需要在流水线间进行传递，直至流水线的最后阶段，然后再进行处理。

### 异步中断

异步中断信号由中断控制器直接检测。

## 中断处理

中断处理需要和CP0（CatPad0）协处理器进行一些沟通来完成。

协处理器中包含下面的与中断处理相关的寄存器：

| 寄存器名称 | 作用描述 |
| ---------- | -------- |
| epc(16)        | 中断返回指令地址 |
| cause(16)      | 中断原因 |
| status     | 处理器工作态（是否禁用中断） |

### cause寄存器

| 位 | 描述 |
| --- | ---- |
| 15  | 中断是否位于延迟槽 |
| 14 - 11 | 当前处理的中断类型 |
| 10 - 0 | 待处理的中断 |

## 中断号
| 中断号 | 描述 |
| -----  | ---- |
| a      | PS/2中断请求 |
| 9      | 超时中断请求 |

