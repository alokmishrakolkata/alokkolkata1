@isTest
private class PublicGroupsTabControllerTest {

    static testMethod void myController() {
        
        Group grp1 = new Group(name = 'Sutar');
        insert grp1;
        
        Group grp2 = new Group(name = 'Anil');
        insert grp2;
        
        GroupMember gm1 = new GroupMember(GroupId = grp1.id, UserOrGroupId = grp2.id);
        insert gm1;
        
        GroupMember gm2 = new GroupMember(GroupId = grp2.id, UserOrGroupId = UserInfo.getUserId());
        insert gm2;
        
        UserRole rol = new UserRole(name = 'MMMM');
        insert rol;
        
        User u = new User(id = UserInfo.getUserId(),UserRoleId = rol.id);
        update u;
        
        PublicGroupsTabController con = new PublicGroupsTabController();
        con.reDirect();
        
    }
}