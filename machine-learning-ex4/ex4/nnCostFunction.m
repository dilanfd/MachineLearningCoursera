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

% Forward propagation.
X = [ones(m,1) X]; % added a column of 1s to X.
a1 = X;
z2 = a1 * Theta1';
a2 = sigmoid(z2);
%add a column of 1s of *size k* to a2:
k = size(a2,1);
a2 = [ones(k, 1) a2];
%compute z3:
z3 = a2*Theta2';
a3 = sigmoid(z3);

% creating a y_matrix which has the required logical array of size
% 10 by 1 which has 1 if the value is k an zero otherwise for 1 <= k <= K
% and K = numlables. Each row of y_matrix is a logical array (10 by 1) with
%  5000 row for each 5000 examples.

eye_matrix = eye(num_labels);
y_matrix = eye_matrix(y,:);

% Nice trick is to use the double sum with the elementwise multiplication.
% The inner sum aggregates columnwise and the outer sum aggregates row
% wise. Which is precisely what we want.

J = (1/m)*sum(sum(-y_matrix.*(log(a3)) - (1- y_matrix).* (log(1 - a3))));

%unrolls the Theta1 and Theta2 vectors into column vectors
% thetaVec = [Theta1(:); Theta2(:)];
theta1Vec = Theta1(:);
theta2Vec = Theta2(:);

[numRowsTheta1, numColsTheta2] = size(Theta1);
[numRowsTheta2, numColsTheta2] = size(Theta2);
% need to exclude the first columns of Theta1 and Theta2 respectively
% bc we exclude the bias terms from regularization. Therefore we needed to
% find the number of rows and columns for Theta1 and Theta2 as seen in the
% above code. Note that we do not explicetely use numbers here. Thus it
% works for Theta1 and Theta2 of any size.

J = J + (lambda/(2*m))*(sum(theta1Vec(numRowsTheta1 + 1:end).^2) + ...
    sum(theta2Vec(numRowsTheta2 + 1:end).^2));


delta3 = a3 - y_matrix;
unbiasedTheta2 = Theta2(:,2:end); % first column of theta removed
% 
% % computing delta2
delta2 = (delta3 * unbiasedTheta2).*sigmoidGradient(z2);
% 
% % computing Delta1;
Delta1 = delta2' * a1;
% 
% %computing Delta2;
Delta2 = delta3' * a2;
% 
% %computing the (unregularized) gradients;
Theta1_grad = (1/m)* Delta1;
Theta2_grad = (1/m) * Delta2;

%regularization of the gradients.

regularizedTheta1 = (lambda/m) * Theta1;
%overwrite the first column with a column of zeros
regularizedTheta1(:,1) = 0;
regularizedTheta2 = (lambda/m) * Theta2;
%overwrite the first column with a column of zeros
regularizedTheta2(:,1) = 0;

Theta1_grad = Theta1_grad + regularizedTheta1;
Theta2_grad = Theta2_grad + regularizedTheta2;
















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
