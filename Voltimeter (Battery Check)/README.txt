PT

A bateria é de 12V, o PIC18F funciona com 5V, então é necessário baixar a tensão. Com este esquema de voltímetro temos na entrada a tensão da bateria e na saída o proporcional, mas numa escala de 5V.
No ficheiro de simulação estão vários modelos com diferentes amplificadores operacionais, qualquer um serve. No meu projeto utilizei o uA741 porque era o que tinha em stock, mas o LM358 e o LF356 provavelmente são opções mais viáveis porque vão quase a 0V, o que nos dá uma escala maior.


EN

The battery is 12V, the PIC18F works with 5V, so it is necessary to lower the voltage. With this voltmeter diagram we have the battery voltage at the input and the proportional output, but on a 5V scale.
In the simulation file there are several models with different operational amplifiers, any one will do. In my project I used the uA741 because it was what I had in stock, but the LM358 and LF356 are probably more viable options because they go almost to 0V, which gives us a larger scale.