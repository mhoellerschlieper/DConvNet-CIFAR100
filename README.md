# DConvNet-CIFAR100
Delphi ConvNet - convolutional neural network for CIFAR100

This is a ConvNet to Delphi 10 (object pascal) translation.

A Convolution Neural Network in Delphi.

This net learns to categorize images to 100 different categories. The pretrained has an acc of 70%. 

Download the CIFAR-100 binaries (Images) from "https://www.cs.toronto.edu/~kriz/cifar-100-binary.tar.gz" and move them to "Data" directory.

The "Common" directory contains all CNN algorithm sources. The CIFAR_100/work Directory cointais a test project for CIFAR-100. What CIFAR-100 is, you can read at https://www.cs.toronto.edu/~kriz/cifar.html

// =========================================================================
-- Layer: input, fc, dropout, softmax, regression, conv, pool, relu, sigmoid, tanh, maxout, svm
-- Parameter: layer, name, filter_size, filter_count, stride, size, pad, size_x,size_y, depth, activation, dropprob
[Structure]
L001=Layer:Input,   Name:input,  Size_x:32, Size_y:32, Depth:3
L002=Layer:Conv,    Name:conv 1, Filter_Size: 3, Filter_Count:20, Stride:0, Pad:0, Activation:relu
L003=Layer:Pool,    Name:pool 1,  Size:2, Stride:2
L004=Layer:Conv,    Name:conv 2, Filter_Size: 3, Filter_Count:20, Stride:1, Pad:2, Activation:relu
L005=Layer:Pool,    Name:pool 2,  Size:2, Stride:2
L006=Layer:Conv,    Name:conv 3, Filter_Size: 3, Filter_Count:20, Stride:1, Pad:2, Activation:relu
L007=Layer:Conv,    Name:FC, Size:100, Activation:tanh
L008=Layer:softmax, Name:softmax,Size:100

[Options]	
--Methods: adam, adagrad, windowgrad, adadelta, nesterov
method = adagrad
batch_size = 15
// (4) nach jedem Batch werden die Gradienten gelöscht!
learning_rate = 0.01
momentum = 0.9
l1_decay = 0
l2_decay = 0.0001
ro = 0.95
eps = 0.0000001

[Chunk]
// =========================================================================
// DER CHUNK
// ein Block an Infomationen, der sicher gelernt sein muss, bevor der nächste Chunk gelernt werden kann
// wird eine Information nicht gelernt, so kommt sie in den nächsten Chank zum wiederholten Lernen
// Chunklernen einschalten
ChunkEnabled = 0            
// Anzahl der zu lernenden Bilder
ChunkSize = 150             
// Anzahl der Wiederholungen
ChunkRepetitions = 4    
// Mindest-W-keit, dass eine Information als gelernt akzeptiert wird    
ChunkAccLikeliHood = 0.8    
// Mindest-W-keit, dass eine Information als nicht gelernt akzeptiert wird
ChunkNonAccLikeliHood = 0.2 

[Data_Filenames]
Labels=.\Data\cifar-100-binary\coarse_label_names.txt
DetailLabels=.\Data\cifar-100-binary\fine_label_names.txt
TrainData=.\Data\cifar-100-binary\train.bin
TestData=.\Data\cifar-100-binary\test.bin

Weights= .\Weights.net
Results= .\Results.csv
