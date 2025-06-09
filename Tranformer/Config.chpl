config param warmupStep: int = 4000;
config param beta1: real = 0.9;
config param beta2: real = 0.98;
config param eps: real = 1e-9;

config param dModel: int = 24; // 512
config param head: int = 1; // 8
config param sequenceLength: int = 16;
config param qshape: int = 16;
config param dFF: int = 128; // 256

config param epoch: int = 2;
config param batch: int = 8;

config param dropoutRate: real = 0.1;