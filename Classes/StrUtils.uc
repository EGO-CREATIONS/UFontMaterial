// ========================================================================================
//  Package/class	:	UFontMaterials.StrUtils
//	Autor			    :	Jan "eGo" Urbansky
//	WWW				    :	http://www.ego-creations.de
//	Script Version:	0.1
//	last changed	:	12.03.2005 - 08:24
//
//	Description		:	some useful functions
// ========================================================================================
class StrUtils extends Main;

// ========================================================================================
//	String Replacement
// ========================================================================================
simulated static final function StrReplace(out string Text, string OldString, string NewString)
{
	local int i;
	local string s;

	if ( Text == "" || OldString == "" )
		return;

	s = Text;
	Text = "";
	i = InStr(s, OldString);
	while(i != -1)
	{
		Text = Text $ Left(s, i) $ NewString;
		s = Mid(s, i + Len(OldString));
		i = InStr(s, OldString);
	}
	Text = Text $ s;
}

defaultproperties
{
}
