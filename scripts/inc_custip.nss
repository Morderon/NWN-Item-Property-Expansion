//#include "nwnx_events"
#include "nwnx_effect"
#include "nwnx_creature"
#include "nwnx_itemprop"
//Bonus functions, used interally:
void EffectImmunityBypass(object oCreature, int nChance=100, int nImmunityType=-255, int bPersist=FALSE)
{
    NWNX_Creature_SetBypassEffectImmunity(oCreature, nImmunityType, nChance, bPersist);
}

void SQLite_SimpleQuery(object oObject, string sQuery)
{
    sqlquery sql = SqlPrepareQueryObject(oObject, sQuery);
    SqlStep(sql);
}
//For custom ips

//returns true if oItem has any custom item properties
int HasSpecialProps(object oItem);
//Convers item property into an effect only works for custom ips
effect ConverItemPropToEffect(object oItem, int nType, int nSubType, int nCost, int nParam, string sPropID, int nRace=-1, int nLC=ALIGNMENT_ALL, int nGE=ALIGNMENT_ALL, int nDmgVS=-1, int nSaveType=SAVING_THROW_TYPE_ALL);
//Applyies the item properties as effects for oItem. call this onModule equip
void ApplyItemPropEffects(object oPC, object oItem);
//put this on load
void CreateCustIPTables();

effect ConverItemPropToEffect(object oItem, int nType, int nSubType, int nCost, int nParam, string sPropID, int nRace=-1, int nLC=ALIGNMENT_ALL, int nGE=ALIGNMENT_ALL, int nDmgVS=-1, int nSaveType=SAVING_THROW_TYPE_ALL)
{

    effect eEffect;
    switch(nType)
    {
        case 151: eEffect = EffectAttackIncrease(nCost, nSubType); break;
        case 152: eEffect = EffectAttackDecrease(nCost, nSubType); break;
        case 153: eEffect = EffectConcealment(nCost, nSubType); break;
        case 154: switch(nSubType)
                 {
                    case 0: eEffect = EffectEthereal(); break;
                    case 3: eEffect = EffectSanctuary(nCost); break;
                    default: eEffect = EffectInvisibility(nSubType); break;
                 }
                 break;
       case 155: switch(nSubType)
                {
                    case 0: eEffect = EffectUltravision(); break;
                    case 1: eEffect = EffectSeeInvisible(); break;
                    case 2: eEffect = EffectCutsceneGhost(); break;
                    case 3: eEffect = EffectBlindness(); break;
                    case 4: eEffect = EffectCutsceneImmobilize(); break;
                    case 5: eEffect = EffectEntangle(); break;
                    case 6: eEffect = EffectDeaf(); break;
                    case 7: eEffect = EffectSilence(); break;
                    case 8: eEffect = EffectSlow(); break;
                }
                break;
       case 156:
                switch(nSubType)
                {
                    case 0: eEffect = EffectMovementSpeedIncrease(nCost); break;
                    case 1: eEffect = EffectMovementSpeedIncrease(-nCost); break;
                    case 2: eEffect = EffectModifyAttacks(nCost > 5 ? 5:nCost); break;
                    case 3: eEffect = EffectModifyAttacks(-nCost); break;
                    case 4: eEffect = EffectNegativeLevel(nCost); break;
                case 5: eEffect = EffectSpellResistanceDecrease(nCost); break;
                }
                break;
       case 157:
            {
                int nDmg;

                switch(nDmgVS)
                {
                    case 0: nDmg = DAMAGE_TYPE_BLUDGEONING; break;
                    case 1: nDmg = DAMAGE_TYPE_PIERCING; break;
                    case 2: nDmg = DAMAGE_TYPE_SLASHING; break;
                    default: nDmg = AC_VS_DAMAGE_TYPE_ALL; break;
                }
                eEffect = EffectACIncrease(nCost, nSubType, nDmg);
                break;
            }
       case 158:
            {
                int nSchool;
                if(nSubType == 8)
                    nSchool = SPELL_SCHOOL_GENERAL;
                else
                    nSchool = nSubType + 1;

                eEffect = EffectSpellFailure(nCost, nSchool); break;
            }
       case 159: eEffect = EffectRegenerate(nCost, IntToFloat(nParam)); break;
       case 160:
            {
                int nSchool;
                if(nSubType == 8)
                    nSchool = SPELL_SCHOOL_GENERAL;
                else
                    nSchool = nSubType + 1;
                eEffect = EffectSpellLevelAbsorption(nCost, 0, nSchool); break;
            }
       case 161: eEffect = EffectMissChance(nCost, nSubType); break;
       case 162:
            {
                int nDmg;
                switch(nSubType)
                {
                    case 1: nDmg = DAMAGE_TYPE_PIERCING; break;
                    case 2: nDmg = DAMAGE_TYPE_SLASHING; break;
                    case 5: nDmg = DAMAGE_TYPE_MAGICAL; break;
                    case 6: nDmg = DAMAGE_TYPE_ACID; break;
                    case 7: nDmg = DAMAGE_TYPE_COLD; break;
                    case 8: nDmg = DAMAGE_TYPE_DIVINE; break;
                    case 9: nDmg = DAMAGE_TYPE_ELECTRICAL; break;
                    case 10: nDmg = DAMAGE_TYPE_FIRE; break;
                    case 11: nDmg = DAMAGE_TYPE_NEGATIVE; break;
                    case 12: nDmg = DAMAGE_TYPE_POSITIVE; break;
                    case 13: nDmg = DAMAGE_TYPE_SONIC; break;
                    default: nDmg = DAMAGE_TYPE_BLUDGEONING; break;
                }
                eEffect = EffectDamageShield(nParam, nCost, nDmg); break;
            }
       case 167: eEffect = EffectSkillDecrease(nSubType, nCost); break;
       case 168: eEffect = EffectSkillIncrease(nSubType, nCost); break;
       case 170:
            {
                int nDmg;

                switch(nDmgVS)
                {
                    case 0: nDmg = DAMAGE_TYPE_BLUDGEONING; break;
                    case 1: nDmg = DAMAGE_TYPE_PIERCING; break;
                    case 2: nDmg = DAMAGE_TYPE_SLASHING; break;
                    default: nDmg = AC_VS_DAMAGE_TYPE_ALL; break;
                }

                eEffect = EffectACDecrease(nCost, nSubType, nDmg);
                break;
            }
       case 172: eEffect = EffectSavingThrowIncrease(nSubType, nCost, nSaveType); break;
       case 173: eEffect = EffectSavingThrowDecrease(nSubType, nCost, nSaveType); break;
       case 174: eEffect = EffectImmunity(nSubType); break;
       case 163: eEffect = EffectVisualEffect(nSubType); break;
       case 164: eEffect = EffectAreaOfEffect(nSubType); break;

    }
    if(nRace > -1)
        eEffect = VersusRacialTypeEffect(eEffect, nRace);
    if(nLC != ALIGNMENT_ALL || nGE != ALIGNMENT_ALL)
        eEffect = VersusAlignmentEffect(eEffect, nLC, nGE);

    struct NWNX_EffectUnpacked unpe = NWNX_Effect_UnpackEffect(eEffect);
    unpe.oCreator = oItem;
    unpe.sItemProp=sPropID;
    unpe.nSubType=3;
    if(nType == 174)
        unpe.nParam4=nCost;
    eEffect = NWNX_Effect_PackEffect(unpe);

    return eEffect;
}

void ApplyItemPropEffects(object oPC, object oItem)
{
    //for some reason oPC is invalid on every login except the first, this fixes it.
    if(!GetIsObjectValid(oPC))
        oPC = GetItemPossessor(oItem);


    int nCont;

    sqlquery sql;
    string sResRef = GetResRef(oItem);

    object oModule = GetModule();
    int nType;
    struct NWNX_IPUnpacked unpip;
    SQLite_SimpleQuery(oModule, "DELETE FROM cust_race");
    SQLite_SimpleQuery(oModule, "DELETE FROM cust_ip");
    SQLite_SimpleQuery(oModule, "DELETE FROM cust_align");
    SQLite_SimpleQuery(oModule, "DELETE FROM cust_save");
    SQLite_SimpleQuery(oModule, "DELETE FROM cust_dmg");
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {

        nType = GetItemPropertyType(ip);
        if(nType > 87)
        {
            nCont=TRUE;
            if(nType == 165)
            {
                sql = SqlPrepareQueryObject(oModule, "INSERT INTO cust_race VALUES (@id,@race)");
                SqlBindInt(sql, "@id", GetItemPropertyParam1Value(ip));
                SqlBindInt(sql, "@race", GetItemPropertySubType(ip)+1);
            }
            else if(nType == 166)
            {
                sql = SqlPrepareQueryObject(oModule, "INSERT INTO cust_align VALUES (@id,@lc,@ge)");
                SqlBindInt(sql, "@id", GetItemPropertyParam1Value(ip));
                SqlBindInt(sql, "@lc", GetItemPropertySubType(ip));
                SqlBindInt(sql, "@ge", GetItemPropertyCostTableValue(ip));
            }
            else if(nType == 169)
            {
                sql = SqlPrepareQueryObject(oModule, "INSERT INTO cust_dmg VALUES (@id,@dmg)");
                SqlBindInt(sql, "@id", GetItemPropertyParam1Value(ip));
                SqlBindInt(sql, "@dmg", GetItemPropertySubType(ip)+1);
            }
            else if(nType == 171)
            {
                sql = SqlPrepareQueryObject(oModule, "INSERT INTO cust_save VALUES (@id,@save)");
                SqlBindInt(sql, "@id", GetItemPropertyParam1Value(ip));
                SqlBindInt(sql, "@save", GetItemPropertySubType(ip));
            }
            else
            {
                unpip = NWNX_ItemProperty_UnpackIP(ip);
                sql = SqlPrepareQueryObject(oModule, "INSERT INTO cust_ip VALUES (@type,@subtype,@cost,@param,@propid)");
                SqlBindInt(sql, "@type", nType);
                SqlBindInt(sql, "@cost", unpip.nCostTableValue);
                SqlBindInt(sql, "@param", unpip.nParam1Value);
                SqlBindInt(sql, "@subtype", unpip.nSubType);
                SqlBindString(sql, "@propid", unpip.sID);
            }
            SqlStep(sql);
        }

        ip = GetNextItemProperty(oItem);
    }

    if(nCont)
    {
        string sVersus = "AND i.type IN (151,152,153,154,167,168,170,157,172,173,174)"; // the properties that allow versus properties
        /*if((!GetIsPC(oPC) || GetIsDMPossessed(oPC)))
        {
            NWNX_Events_AddObjectToDispatchList("NWNX_ON_ITEM_EQUIP_AFTER", "evt_eqpnpc_aft", oPC);
        }*/
        sql = SqlPrepareQueryObject(oModule, "SELECT i.type,i.subtype,i.cost,i.param,i.propid,r.race,a.lc,a.ge,d.dmg,s.save FROM cust_ip i LEFT JOIN cust_race r ON  r.id=i.param " +sVersus+ " LEFT JOIN cust_align a ON i.param=a.id "+sVersus+" LEFT JOIN cust_dmg d ON d.id=i.param AND i.type IN (170,157) LEFT JOIN cust_save s ON s.id=i.param AND i.type IN (172,173)");

        EffectImmunityBypass(oPC);
        while(SqlStep(sql))
        {
            NWNX_Effect_Apply(ConverItemPropToEffect(oItem, SqlGetInt(sql,0), SqlGetInt(sql,1), SqlGetInt(sql,2), SqlGetInt(sql,3), SqlGetString(sql,4), SqlGetInt(sql,5)-1, SqlGetInt(sql,6), SqlGetInt(sql,7), SqlGetInt(sql,8)-1, SqlGetInt(sql,9)), oPC);
        }
        EffectImmunityBypass(oPC, 0);
    }

}

int HasSpecialProps(object oItem)
{
    itemproperty ip = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ip))
    {
        if(GetItemPropertyType(ip) > 87)
            return TRUE;
        ip = GetNextItemProperty(oItem);
    }

    return FALSE;
}

void CreateCustIPTables()
{
  SQLite_SimpleQuery(OBJECT_SELF, "CREATE TABLE cust_ip (type INTEGER, subtype INTEGER, cost INTEGER, param INTEGER, propid TEXT)");
  SQLite_SimpleQuery(OBJECT_SELF, "CREATE TABLE cust_align (id INTEGER, lc INTEGER, ge INTEGER)");
  SQLite_SimpleQuery(OBJECT_SELF, "CREATE TABLE cust_race (id INTEGER, race INTEGER)");
  SQLite_SimpleQuery(OBJECT_SELF, "CREATE TABLE cust_dmg (id INTEGER, dmg INTEGER)");
  SQLite_SimpleQuery(OBJECT_SELF, "CREATE TABLE cust_save (id INTEGER, save INTEGER)")	
}