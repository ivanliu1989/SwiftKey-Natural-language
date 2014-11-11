library(RWeka)
txt <- "I don’t know. Maybe they’re getting too much sun. I think I’m going to cut them way back. I replied."
NGramTokenizer(txt, Weka_control(min = 2, max = 3, delimiters = " \\r\\n\\t.,;:\"()?!"))
