os.pullEvent = function( _sFilter )
  eventData = {os.pullEventRaw( _sFilter } -- os.pullEventRaw will give us the raw event data and store it in this table
  if eventData[1] == "terminate" then -- identify the event and see if its terminate
        programName = shell.getRunningProgram()
        error("User has terminated the program: "..programName,0)
         -- this example changes it to say the text between the quotes and then the name of the program
         -- change the code after the 'if' to do whatever you want with the terminate even if its nothing
  end
end
