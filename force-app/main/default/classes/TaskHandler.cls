public class TaskHandler {
    
   //WhenEver a Task is created, Set the Priority To High
    public static void taskMethod1(List<Task> taskList){
        for(Task tskNewRec : taskList){
                tskNewRec.Priority = 'High';    
        }
    }

}