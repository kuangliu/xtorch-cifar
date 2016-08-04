require 'pl'
require 'nn'
require 'nnx'
require 'torch'
require 'optim'
require 'image'
require 'paths'

utils = dofile('utils.lua')
xtorch = dofile('xtorch.lua')

------------------------------------------------
-- 1. prepare data
--
dofile('listdataset.lua')
ds = ListDataset({
    trainData = '/search/ssd/liukuang/cifar10/train/',
    trainList = '/search/ssd/liukuang/cifar10/train.txt',
    testData = '/search/ssd/liukuang/cifar10/test/',
    testList = '/search/ssd/liukuang/cifar10/test.txt',
    imsize = 32,
    imfunc = nil -- image processing function, default: zeromean & normalization
})

------------------------------------------------
-- 2. define net
--
net = nn.Sequential()
net:add(nn.Reshape(32*32*3))
net:add(nn.Linear(32*32*3, 512))
net:add(nn.ReLU(true))
net:add(nn.Dropout(0.2))
net:add(nn.Linear(512, 512))
net:add(nn.ReLU(true))
net:add(nn.Dropout(0.2))
net:add(nn.Linear(512, 10))

------------------------------------------------
-- 3. init optimization params
--
optimState = {
    learningRate = 0.01,
    learningRateDecay = 1e-7,
    weightDecay = 1e-4,
    momentum = 0.9,
    nesterov = true,
    dampening = 0.0
}

opt = {
    ----------- net options --------------------
    net = net,
    ----------- data options -------------------
    dataset = ds,
    nhorse = 2,         -- nb of threads to load data, default 2
    ----------- training options ---------------
    batchSize = 128,
    nEpoch = 5,
    nClass = 10,
    ----------- optimization options -----------
    optimizer = 'SGD',
    criterion = 'CrossEntropyCriterion',
    optimState = optimState,
    ----------- general options ----------------
    verbose = false
}

------------------------------------------------
-- 4. and fit!
--
xtorch.fit(opt)
