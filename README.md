# NWN-Item-Property-Expansion

Note: Don't just merge this into your module, examine first as it may contain undesired modifications.
ie: Additional property uses the cost table for new ips and not param1 as is default.

Works with vs align/race	
AB (pos, neg)	Can select which hand
Concealment	Can select distance
Visibility (invisibility/sanctuary/greater sanc)	
Skill (pos and neg)	
AC (pos, neg)	Able to select AC type, works with vs Dmg type too
Damage bonus (pos, neg)	Not yet implemented
Saving throw neg/pos	Works with vs saves. Able to select a major and minor on the same item property
Immunities	much increased list, also supports a % in cost table (needs NWNX support that doesn't yet exist)

Misc (movement speed modification, extra/lower attacks, level drain, spell resistance decrease)	
Other (ultravision, slow, immobilze, see invisiblity, blindness, deafness, silence, cutsceneghost)	
Spell failure	able to select school, works with both divine and arcane
Regenerate	Able to select interval
Damage shields	
Miss chance	Able to select distance
Spell immunity	able to select school and up to what circle
VfX	Don't see your favorite vfx? modify the 2da  to add it
Area of Effects	Don't see your favorite vfx? modify the 2da  to add it. These will also require script edits,
Spells	use param 1 to set a custom caster level

How to use the vs. system
Select a property that supports the vs system (those above)
Select a  vs property and decide the effects restrictions
Give them matching param 1's
Example:

AB + 1  (Param 1)
vs Elf (Param 1)
vs Dwarf (Param 1)
vs Lawful Evil (Param 1)
AC +1  (Param 2)
vs Neutral/ALL (Param 2)
vs All/Good (param 2)

Will give AB vs Lawful Evil Dwarves or Lawful Evil Elves
Will give AC vs all neutral (on the law/chaos axis) and sll good



-----------

To get the item properties to work on creatures you'd need to loop through their equipped items on spawn and apply the custom ips
You also may want to subscribe to NWNX's on equip events so creatures get new ips when the switch items.


