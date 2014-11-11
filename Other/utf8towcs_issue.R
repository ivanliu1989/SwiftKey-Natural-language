tryTolower = function(x)
{
    # create missing value
    # this is where the returned value will be
    y = NA
    # tryCatch error
    try_error = tryCatch(tolower(x), error = function(e) e)
    # if not an error
    if (!inherits(try_error, "error"))
        y = tolower(x)
    return(y)
}
tryTolower
# vector with text
text_vector = c(
    "Motivation, philosophy and technique in activism. #Assange and #Occupy: http://t.co/89PFkyjh via @RT_com",
    "No work today, slept through the classes I wanted at the gym. Now I need to find something to occupy my time \ud83d\udc4d\ud83d\ude09",
    "RT @jdavis4100: The Spirit of God and fear never occupy the same space. The presence of one automatically implies the absence of the other...",
    "Police given powers to enter homes http://t.co/VXmtfPV5 and tear down anti- #Olympics posters during Games #Occupy #Anonymous #wakeup #fb",
    "RT @OccupyWallSt: RT @WSOASP12: I quit my job to join the occupy movement. Time to stand up and speak out, I'm not here to make another man rich @Occupy #OWS")

# apply tolower (you should get an error message)
tolower(text_vector)

# now apply tryTolower with sapply
# (you should get a missing value when tryTolower finds an error) 
sapply(text_vector, function(x) tryTolower(x))
