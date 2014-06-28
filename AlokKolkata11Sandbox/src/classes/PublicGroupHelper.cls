public class PublicGroupHelper {
    //zScratchPad2.method1();
    
    public static Group [] lstGroups = [Select Type, RelatedId, OwnerId, Name, Id, Email, DoesSendEmailToMembers, DoesIncludeBosses,(Select UserOrGroupId, SystemModstamp, Id,group.name,group.type, GroupId from GroupMembers),(Select Id, QueueId, SobjectType, CreatedById, SystemModstamp From QueueSobjects) From Group order by Name];
    public static Map<Id,CGroup> mapCGroup = new Map<Id,CGroup>();
    public static CGroup [] lstCGroups = new List<CGroup>();
    public static Map<Id,Set<CGroup>> mapReleatedId_CGroup = new Map<Id,Set<CGroup>>();
    public static Map<Id,Set<CGroup>> mapUserRole_CGroup = new Map<Id,Set<CGroup>>();
    
    public static User [] lstUser = [Select Username, UserType, UserRoleId, Name, IsActive From User ];
    public static Map<id,User> mapUser = new Map<id,User>(lstUser);
    
    public static Map<Id,Set<CGroup>> mapUserId_InDirectCgroups = new Map<Id,Set<CGroup>>();
    public static Map<Id,Set<CGroup>> mapUserId_DirectCgroups = new Map<Id,Set<CGroup>>(); 
    
    
    public static void updateUserGroups(){
        for(Group gp: lstGroups){
            CGroup temp = new CGroup(gp);
            mapCGroup.put(gp.id,temp);
            lstCGroups.add(temp);
            
            if(gp.RelatedId != null){
                if(mapReleatedId_CGroup.get(gp.RelatedId) == null)
                    mapReleatedId_CGroup.put(gp.RelatedId, new Set<CGroup>());
                
                mapReleatedId_CGroup.get(gp.RelatedId).add(temp);
                system.debug('111111111111111111'+mapReleatedId_CGroup.get(gp.RelatedId).size());
            }
        }
        
        system.debug(mapReleatedId_CGroup+')))))))');
        
        Map<id,Set<CGroup>> parentChildMap  = new Map<id,Set<CGroup>>(); 
        for(CGroup cg: mapCGroup.values()){
            if(parentChildMap.get(cg.grp.id) == null)
                parentChildMap.put(cg.grp.id,new Set<CGroup>());
        
            parentChildMap.get(cg.grp.id).add(cg);
                
        }
        
        
        for(Group gp:lstGroups){
            CGroup parentGroup = mapCGroup.get(gp.id);
            for(GroupMember gm: gp.GroupMembers){
                
                system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+gm.group.name);
                
                String usrOrGroupId = gm.UserOrGroupId;
                if(usrOrGroupId.startswith('00G')){//add as a child in parend CGroup
                    CGroup currentGroup = mapCGroup.get(usrOrGroupId);
                    currentGroup.parentCGroup = parentGroup;
                    currentGroup.parentCGroups.add(parentGroup);
                    currentGroup.childCGroups = parentChildMap.get(usrOrGroupId);
                    parentGroup.childCGroups.add(currentGroup);
                    
                }else if(usrOrGroupId.startswith('005')){//Add as a child user in parent CGroup
                    if(mapUserId_DirectCgroups.get(usrOrGroupId)==null)
                        mapUserId_DirectCgroups.put(usrOrGroupId,new Set<CGroup>());
                        
                    mapUserId_DirectCgroups.get(usrOrGroupId).add(parentGroup);
                }
            }
        }
        
        for(CGroup cg: lstCGroups){
            cg.parentCGroups.add(cg);
            if(cg.childCGroups.size()==0){
                system.debug('                                                          null found+++++++++++++++++');
            }else{
                if(cg.parentCGroup != null )
                    updateLastNode(cg,cg.parentCGroup);
            }
        }
        
        
        for(User usrGp: lstUser){
            if(usrGp.UserRoleId!=null){
                if(mapUserId_InDirectCgroups.get(usrGp.id)==null)
                    mapUserId_InDirectCgroups.put(usrGp.id,new Set<CGroup>());
                mapUserId_InDirectCgroups.get(usrGp.id).addAll(mapReleatedId_CGroup.get(usrGp.UserRoleId));
                //mapUserId_InDirectCgroups.get(usrGp.id).addAll(mapUserId_InDirectCgroups.get(usrGp.UserRoleId));
                
                system.debug('      mapReleatedId_CGroup.get(usrGp.UserRoleId)-----------'+mapUserId_InDirectCgroups.get(usrGp.id).size());
            }
            
            //system.debug('      User-----------'+mapUserId_InDirectCgroups.get(usrGp.id).size());
        }
        
        system.debug('      mapUserId_InDirectCgroups-----------'+mapUserId_InDirectCgroups);
        system.debug('      mapUserId_DirectCgroups-----------'+mapUserId_DirectCgroups);
        
        List<User_Groups__c> userGroups = [select id,User__c from User_Groups__c];
        Map<Id,User_Groups__c> mapUserGroups = new Map<id,User_Groups__c>();
        for(User_Groups__c usrGp: userGroups){
            mapUserGroups.put(usrGp.User__c,usrGp);
        }
        
        for(User cu:lstUser){
            
            
            Set<CGroup> InDirectCgroups = mapUserId_InDirectCgroups.get(cu.id);
            
            Set<CGroup> DirectCgroups = mapUserId_DirectCgroups.get(cu.id);
            if(InDirectCgroups==null){
                InDirectCgroups = new Set<CGroup>();
            }
            if(DirectCgroups==null){
                DirectCgroups = new Set<CGroup>();
            }
            
            system.debug(InDirectCgroups.size()+'indirect:'+InDirectCgroups);
            
            Set<String> directG = new set<String>();
            Set<String> inDirectG = new set<String>();
            Set<String> allG = new set<String>();
            
            Set<String> directQ = new set<String>();
            Set<String> inDirectQ = new set<String>();
            Set<String> allQ = new set<String>();
            system.debug('      InDirectCgroups-----------'+InDirectCgroups);
            for(CGroup cg: InDirectCgroups){
                system.debug('++++___'+cg.grp);
            
                
                if(cg.grp.type=='Regular'){
                    DirectG.add(cg.grp.name);
                }
                if(cg.grp.type=='Queue'){
                    DirectQ.add(cg.grp.name);
                }
                for(CGroup cg1:cg.parentCGroups){
                    if(cg1.grp.type=='Regular'){
                        inDirectG.add(cg1.grp.name);
                    }
                    if(cg1.grp.type=='Queue'){
                        inDirectQ.add(cg1.grp.name);
                    }
                }
            }
            inDirectG.remove(null);
            inDirectQ.remove(null);
            
            for(CGroup cg: DirectCgroups){
                if(cg.grp.type=='Regular'){
                    directG.add(cg.grp.name);
                }
                if(cg.grp.type=='Queue'){
                    directQ.add(cg.grp.name);
                }
                for(CGroup cg1:cg.parentCGroups){
                    if(cg1.grp.type=='Regular'){
                        inDirectG.add(cg1.grp.name);
                    }
                    if(cg1.grp.type=='Queue'){
                        inDirectQ.add(cg1.grp.name);
                    }
                }
            }
            directG.remove(null);
            directQ.remove(null);
            inDirectG.remove(null);
            inDirectQ.remove(null);
            
            inDirectQ.removeAll(directQ);
            inDirectG.removeAll(directG);
            
            allG.addall(directG);
            allQ.addall(directQ);
            allG.addall(inDirectG);
            allQ.addall(inDirectQ);
            
            
            system.debug('----------------------------------------1'+directG);
            system.debug('----------------------------------------2'+directQ);
            
            system.debug('----------------------------------------3'+inDirectG);
            system.debug('----------------------------------------4'+inDirectQ);
            system.debug('----------------------------------------55'+mapReleatedId_CGroup);
            
            
            if(mapUserGroups.get(cu.id) == null)
                mapUserGroups.put(cu.id,new User_Groups__c());
                
            User_Groups__c ug = mapUserGroups.get(cu.id);
            
            ug.User__c = cu.id;
            ug.isActive__c = cu.isActive;
            
            ug.Direct_Groups__c = getString(directG)==''?'-':getString(directG);
            ug.All_Groups__c = getString(allG)==''?'-':getString(allG);
            ug.InDirect_Groups__c = getString(inDirectG)==''?'-':getString(inDirectG);
            
            ug.Direct_Queues__c = getString(directQ)==''?'-':getString(directQ);
            ug.InDirect_Queues__c = getString(inDirectQ)==''?'-':getString(inDirectQ);
            ug.All_Queues__c = getString(allQ)==''?'-':getString(allQ);
            
        }
        
        if(!Test.isRunningTest())
        	upsert mapUserGroups.values();
        
        
        
        
    }
    public static String getString(Set<String> setvalue){
        String val = String.valueof(setvalue);
        return val.substring(1,val.length()-1);
        
        
    }
        
    public static void updateLastNode(CGroup cg,CGroup pg){
        cg.parentCGroups.add(pg);
        if(pg.parentCGroup != null)
            updateLastNode(cg,pg.parentCGroup);
    }
    public class CGroup{
        public CGroup parentCGroup {get;set;}
        public Set<CGroup> childCGroups = new Set<CGroup>(); 
        public Set<CGroup> parentCGroups = new Set<CGroup>();
        public Group grp {get;set;}
        
        public CGroup(Group gp){
            this.grp = gp;
        }
        
        public Set<Id> userIds = new set<id>();
        
         
    }


}