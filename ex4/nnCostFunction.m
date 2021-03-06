function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
J=0;
grad=0;

Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

  
% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

Y = labelMatrix(y,num_labels);

% Part 1 cost function for NN
a1 = [ones(m,1) X];
z2 = a1*Theta1';
size(z2);
a2 = [ones(m,1) sigmoid(z2)];
size(a2);
z3 = a2 * Theta2';
size(z3);
a3 = sigmoid(a2 * Theta2');
size(a3);
sumM=0;
for i = 1:m
   for k = 1:num_labels
     sumM = sumM + (Y(i,k)*log(a3(i,k))+((1-Y(i,k))*log(1-(a3(i,k)))));
   endfor
endfor

[Theta1_row, Theta1_col] =  size(Theta1);
[Theta2_row, Theta2_col] =  size(Theta2);

%compute regularization for Theta1
Theta2;
regularization = 0;
for i = 1: Theta1_row
  for j = 2: Theta1_col
    regularization = regularization + Theta1(i,j)^2;
  endfor
endfor

for i = 1:Theta2_row
  for j = 2:Theta2_col
     regularization = regularization + Theta2(i,j)^2;
  endfor
endfor
%compute regularization for Theta2

regularization = (lambda/(2*m)) * regularization;

J = (sumM * (-1/m)) + regularization;


%Part 2 back propagations
% with for loop

delta_3 = 0;
delta_2 = 0;

DELTA_2 = 0;
DELTA_3 = 0;
for t = 1:m
  a1_t = a1(t,:);
  z2_t = z2(t,:);
  a2_t = a2(t,:);
  z3_t = z3(t,:);
  a3_t = a3(t,:);
  y_t = Y(t,:);
  delta_3 = a3_t - y_t;
  delta_3 = delta_3';
  delta_2 = (Theta2' * delta_3)(2:end,:) .* sigmoidGradient(z2_t');
  
  grad_1 = delta_2 * a1_t;
  grad_2 = delta_3 * a2_t;
  DELTA_2 = DELTA_2 + grad_1;
  DELTA_3 = DELTA_3 + grad_2;
endfor


DELTA_2 = (1/m)*DELTA_2;
DELTA_3 = (1/m)*DELTA_3;

DELTA_2_regularization_sum = (lambda/m) * [zeros(size(Theta1,1),1) Theta1(:,2:end)];
DELTA_2 = DELTA_2 + DELTA_2_regularization_sum;

DELTA_3_regularization_sum = (lambda/m) * [zeros(size(Theta2,1),1) Theta2(:,2:end)];
DELTA_3 = DELTA_3 + DELTA_3_regularization_sum;

%add regularization

Theta1_grad = DELTA_2;
Theta2_grad = DELTA_3;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
