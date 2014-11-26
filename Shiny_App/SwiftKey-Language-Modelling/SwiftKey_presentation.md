Introduction of SwiftKey Data Product - Mobile Typing Prediction
========================================================
author: Tianxiang(Ivan) Liu
date: 25 November 2014
transition: rotate
class: illustration
rtl: false
css: custom.css
navigation: slide
font-family: 'Risque'

Outline
========================================================
type: prompt
- <b>**Prediction Algorithm**</b>
    - Efficient Modelling - ~~Markov Chain / Katz back-off~~
    - Cleaned/Compressed Datasets - ~~580MB -> 36MB~~
    - Quick predictive response - ~~0.000~0.003s~~ 
- <b>**Instructions**</b>
    - Input - ~~Sentence (truncate the last 1~4 words)~~
    - Output - ~~Top possible words / Wordcloud visualization~~
- <b>**Experience of Application**</b>
    - User Interface - ~~Shiny server / Amazon EC2~~
    - Manual / Documents 

Prediction Algorithm
========================================================
type: prompt
- <b>**Markov Chain**</b><br>

    ![Markov Chain](markov.png)
- <b>**Kat back-off**</b> <br>
    ![Kat backoff](work_flow_shiny.png)
    
Instructions
========================================================
type: prompt
<b>**Text Input**</b><br>
    ![Input](text_input.png)
***
<b>**Prediction Outcomes**</b>
- Word prediction<br>
![Prediction](prediction.png)
- Wordcloud<br>
![Wordcloud](wordcloud.png)


Experience of App
========================================================
type: prompt
- <b>**Predictive Model**</b>
- <b>**App Workflow**</b>
- <b>**Key Concepts**</b>


