//Do this trigger to create Chatter Group before the process to insert Post.
trigger TargetTrigger on Trade__c (before insert) {

  if (Trigger.isInsert) { 
    String chatterName = 'Trade reviewers';
    if(Test.isRunningTest()) {
      chatterName = chatterName+Integer.valueof((Math.random() * 10));
    }
    List<CollaborationGroup> isExist = [ SELECT Id, Name FROM CollaborationGroup WHERE Name = :chatterName LIMIT 1];
  
    // The logic should be in the TriggerHandler
    if(isExist.IsEmpty()) {
      CollaborationGroup chatterGroup = new CollaborationGroup();
      chatterGroup.Name = chatterName;
      chatterGroup.CollaborationType = 'Public';
      insert chatterGroup; 
    }
    
  }
}