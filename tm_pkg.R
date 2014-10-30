en_US <- system.file("texts", "txt", package = "tm")

(ovid <- Corpus(DirSource('final/en_US/'),
                readerControl = list(reader = readPlain,
                                     language = "en_US",
                                     load = TRUE)))
Corpus(DirSource(txt),
       readerControl = list(reader = readPlain,
                            language = "la", load = TRUE),
       dbControl = list(useDb = TRUE,
                        dbName = "/home/user/oviddb",
                        dbType = "DB1"))