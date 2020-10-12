### Test Plan
- LCU size
  - 32/64
- 编码档次
  - fast/performance
  - 32 -123 and 64 -1 | LCU size can modify
  - 64 -123           | LCU size can not modify
- I帧
  - frame = 15; gop = 1
- P帧
  - frame = 15; gop = 15 
  - iinp开关(大概率没有)
  - merge开关(大概率没有)
  - 2nxn开关(大概率没有)


### cfg
- ai/ld/lp/ra
  - all intra
  - low delay
  - ?
  - random access


### TODO 1013
- modify extract_*.py to collect psnr and bs rate
- P帧的cfg，应该要扩展到Frame14

### PS
- Gch的wiki，但是cfg是Tgw的