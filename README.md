SwiftKey-Natural-language
=========================

Around the world, people are spending an increasing amount of time on their mobile devices for email, social networking, banking and a whole range of other activities. But typing on mobile devices can be a serious pain. 

SwiftKey, our corporate partner in this capstone, builds a smart keyboard that makes it easier for people to type on their mobile devices. One cornerstone of their smart keyboard is predictive text models. 

##### Tips:
1. P=C(p|w1-w4)/C(w1-w4)
2. Smooth (Katz's back-off model with Good-Turing frequency estimation)
3. Sort
4. Remove longer grams that predict the same results as shorter grams
5. hash reduce size
6. 4grams->3->2->1gram
7. Shiny

##### Please visit the application at:
http://54.201.18.67:3838/SwiftKey-Language-Modelling/
