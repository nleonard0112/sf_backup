public with sharing class rscMissionMemberController {

    private rscMissionMember mMember;

    public rscMissionMemberController(ApexPages.StandardController sc) {
        mMember = rscMissionMember.find.byMemberId((Id)sc.getId());
    }

    public PageReference dispenseSupplies() {
        return new PageReference('/apex/rscDispenseForm?id='+mMember.getId());
    }
}