// ========================================================================================
//  Package/class	:  	ECTools.EC_UFontMaterial
//	Autor		:		      Jan "eGo" Urbansky
//	WWW		:			      http://www.ego-creations.de
//	Script Version	:	0.6
//	last changed	:	  12.03.2005 - 08:33
//
//	NOTE!!!!!!!!!!!!!
//	This script only works correctly with UT2004. Recommend usage with v3186 and higher.
//
//	Used information:
//	http://udn.epicgames.com/Two/FontTutorial
//	http://wiki.beyondunreal.com/wiki/TrueTypeFontFactory
// ========================================================================================

class EC_UFontMaterial extends MaterialFactory;

var class<Texture> MaterialClass;

var() string FontName;
var() float FontSize;

// FW_DONTCARE 0
// FW_THIN 100
// FW_EXTRALIGHT 200
// FW_ULTRALIGHT 200
// FW_LIGHT 300
// FW_NORMAL 400
// FW_REGULAR 400
// FW_MEDIUM 500
// FW_SEMIBOLD 600
// FW_DEMIBOLD 600
// FW_BOLD 700
// FW_EXTRABOLD 800
// FW_ULTRABOLD 800
// FW_HEAVY 900
// FW_BLACK 900

var() enum EFontStyle
{
	Normal,
	Italic,
	Bold,
	Bold_Italic,
	Bolder,
	Bolder_Italic,
} FontStyle;					//UE2 and higher

var() enum EFormat
{
	RGBA8,
	DXT1,
	DXT3,
	DXT5,
} TextureFormat;				//UE2 and higher

var() bool AntiAlias;
var() string Chars;
var() int Count;
//var() int CharactersPerPage;	//UE1 only
var() int DropShadowX;			//UE2 and higher
var() int DropShadowY;			//UE2 and higher
var() int ExtendBoxBottom;		//UE2 and higher
var() int ExtendBoxLeft;		//UE2 and higher
var() int ExtendBoxRight;		//UE2 and higher
var() int ExtendBoxTop;			//UE2 and higher
var() float Gamma;
var() int Kerning;				//UE2 and higher
var() string Path;
var() bool Underline;			//UE2 and higher
var() string UnicodeRange;		//UE2 and higher
var() int USize;
var() int VSize;
var() string Wildcard;
var() int XPad;
var() int YPad;
var() const editconst string Copyright;

// ========================================================================================
//	Returns the font style
// ========================================================================================
private function string GetFontStyle()
{
	local string FS;

	switch( string( GetEnum( enum'EFontStyle',FontStyle ) ) ) {
		case "Normal":				FS = " STYLE=500 ITALIC=FALSE"; break;
		case "Italic":				FS = " STYLE=500 ITALIC=TRUE"; break;
		case "Bold":				FS = " STYLE=600 ITALIC=FALSE"; break;
		case "Bold_Italic":			FS = " STYLE=600 ITALIC=TRUE"; break;
		case "Bolder":				FS = " STYLE=700 ITALIC=FALSE"; break;
		case "Bolder_Italic":		FS = " STYLE=700 ITALIC=TRUE"; break;
	}

	return FS;
}

// ========================================================================================
//	Returns the compression value
// ========================================================================================
private function string GetCompression()
{
	local string CS;

	switch( string( GetEnum( enum'EFormat',TextureFormat ) ) ) {
		case "RGBA8":	CS = ""; break;			// RGBA8
		case "DXT1":	CS = " COMPRESSION=3"; break;	// DXT1
		case "DXT3":	CS = " COMPRESSION=7"; break;	// DXT3
		case "DXT5":	CS = " COMPRESSION=8"; break;	// DXT5
	}
	return CS;
}

// ========================================================================================
//	Builds the console command for the TrueTypeFontFactory
// ========================================================================================
private function string NewTTFMaterial( string InPackage, string InGroup, string InName )
{
	local string S;   								        	// command string declaration

	S = "NEW TrueTypeFontFactory";         		       			// create font with TTF factory
	S = S $ " NAME=\"" $ InName $ "\"";					    	// name of texture
	S = S $ " CLASS=\"" $ string(MaterialClass) $ "\"";    		// name of class
	S = S $ " GROUP=\"" $ InGroup $ "\"";				    	// name of group
	S = S $ " PACKAGE=\"" $ InPackage $ "\"";			    	// name of package
	S = S $ " HEIGHT=" $ string(FontSize);			        	// font height
	S = S $ " USIZE=" $ string(USize);				        	// texture horizontal size
	S = S $ " VSIZE=" $ string(VSize);                      	// texture vertical size
	S = S $ " FONTNAME=\"" $ FontName $ "\"";	   		    	// Windows font name
	S = S $ " YPAD=" $ string(YPad);				        	// texture tiles
	S = S $ " XPAD=" $ string(XPad);				        	// texture tiles
	S = S $ " ANTIALIAS=" $ string(AntiAlias);		        	// antialiasing
	S = S $ " COUNT=" $ string(Count);				        	// char count
	S = S $ " DROPSHADOWX=" $ string(DropShadowX);	        	// shadow width X
	S = S $ " DROPSHADOWY=" $ string(DropShadowY);	        	// shadow width Y
	S = S $ " GAMMA=" $ string(Gamma);				        	// gamma value
//	S = S $ " CHARACTERSPERPAGE=" $ string(CharactersPerPage);
	S = S $ " UNICODERANGE=\"" $ UnicodeRange $ "\"";	   		// Unicode characters, use Hex values comma separated
	S = S $ " WILDCARD=\"" $ Wildcard $ "\"";			    	// includes a file with Unicode characters (e.g. MyChars.*)
	S = S $ " EXTENDBOXBOTTOM=" $ string(ExtendBoxBottom);		// size box of the character letter (bottom edge)
	S = S $ " EXTENDBOXTOP=" $ string(ExtendBoxTop);			// size box of the character letter (top edge)
	S = S $ " EXTENDBOXLEFT=" $ string(ExtendBoxLeft);			// size box of the character letter (left edge)
	S = S $ " EXTENDBOXRIGHT=" $ string(ExtendBoxRight);		// size box of the character letter (right edge)
	S = S $ " UNDERLINE=" $ string(Underline);					// underline style
	S = S $ " PATH=\"" $ Path $ "\"";							// use it with Unicoderange (e.g. ".")
	S = S $ " KERNING=" $ string(Kerning);						// spaces between the characters
	S = S $ GetFontStyle();										// font style
	S = S $ GetCompression();									// compression type

	// add backslashes to a string variable
	class'EC_StrUtils'.static.StrReplace( Chars , Chr(92) , Chr(92) $ Chr(92) );
	class'EC_StrUtils'.static.StrReplace( Chars , Chr(34) , Chr(92) $ Chr(34) );

	S = S $ " CHARS=\"" $ Chars $ "\"";	                    	// chars to include

  	Log( S );													// log the command

	return S;
}

// ========================================================================================
//	Returns the created font material
// ========================================================================================
function Material CreateMaterial( Object InOuter, string InPackage, string InGroup, string InName )
{
	local string sMaterialPath;

	ConsoleCommand ( NewTTFMaterial( InPackage, InGroup, InName ) );

	// Package.Group.Name
	sMaterialPath = InPackage $ "." $ InName $ "." $ InName;

	if( MaterialClass == none ) {
		return none;
	} else {
		return Material( FindObject( sMaterialPath $ "_PageA" , MaterialClass) );
	}
}

// ========================================================================================
//	Default Properties for this Class
// ========================================================================================
defaultproperties
{
	MaterialClass=Engine.Texture
	AntiAlias=False
	Chars=" 0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`~!@#$%^&*()_+-=[]\\{}|;:',./?><\"¡«°»¿ÀÁÄÈÉÊËÌÍÑÒÓÖÙÚÜßàáâäçèéêëìíîïñòóôöùúûüæøå"
	Count=256
	FontName="Arial"
	FontSize=10.000000
	Gamma=0.700000
	Kerning=0
	YPad=1
	XPad=1
	USize=256
	VSize=256
	Description="TrueType Font Texture"
	Copyright="UnrealED Plugin (c) 2004-2005, EGO-CREATIONS"
}
