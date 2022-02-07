/*
 * Test messageParts function.
 */

#include <stdio.h>

const char* response[24] = {
  "\n\n\nHe says:\nMy name is\nLord British,\nSovereign of\nall Britannia!\n",
  "\n\n\n\n\nThou see the\nKing with the\nRoyal Sceptre.\n",
  "\n\n\nHe says:\nI rule all\nBritannia, and\nshall do my best\nto help thee!\n",
  "He says:\nMany truths can\nbe learned at\nthe Lycaeum.  It\nlies on the\nnorthwestern\nshore of Verity\nIsle!\n",
  "He says:\nLook for the\nmeaning of Love\nat Empath Abbey.\nThe Abbey sits\non the western\nedge of the Deep\nForest!\n",
  "\n\nHe says:\nSerpent's Castle\non the Isle of\nDeeds is where\nCourage should\nbe sought!\n",
  "\nHe says:\nThe fair towne\nof Moonglow on\nVerity Isle is\nwhere the virtue\nof Honesty\nthrives!\n",
  "\n\nHe says:\nThe bards in the\ntowne of Britain\nare well versed\nin the virtue of\nCompassion!\n",
  "\n\nHe says:\nMany valiant\nfighters come\nfrom Jhelom\nin the Valarian\nIsles!\n", "\n\n\nHe says:\nIn the city of\nYew, in the Deep\nForest, Justice\nis served!\n",
  "\nHe says:\nMinoc, towne of\nself-sacrifice,\nlies on the\neastern shores\nof Lost Hope\nBay!\n",
  "\nHe says:\nThe Paladins who\nstrive for Honor\nare oft seen in\nTrinsic, north\nof the Cape of\nHeroes!\n",
  "\nHe says:\nIn Skara Brae\nthe Spiritual\npath is taught.\nFind it on an\nisle near\nSpiritwood!\n",
  "\n\n\nHe says:\nHumility is the\nfoundation of\nVirtue!  The\nruins of proud\nMagincia are a\ntestimony unto\nthe Virtue of\nHumility!\n\nFind the Ruins\nof Magincia far\noff the shores\nof Britannia,\non a small isle\nin the vast\nOcean!\n",
  "\n\n\nHe says:\nOf the eight\ncombinations of\nTruth, Love and\nCourage, that\nwhich contains\nneither Truth,\nLove nor Courage\nis Pride.\n\nPride being not\na Virtue must be\nshunned in favor\nof Humility, the\nVirtue which is\nthe antithesis\nof Pride!\n",
  "\n\n\n\n\n\nLord British\nsays:\nTo be an Avatar\nis to be the\nembodiment of\nthe Eight\nVirtues.\n\n\nIt is to live a\nlife constantly\nand forever in\nthe Quest to\nbetter thyself\nand the world in\nwhich we live.\n",
  "\n\n\nLord British\nsays:\nThe Quest of\nthe Avatar is\nto know and\nbecome the\nembodiment of\nthe Eight\nVirtues of\nGoodness!\nIt is known that\nall who take on\nthis Quest must\nprove themselves\nby conquering\nthe Abyss and\nViewing the\nCodex of\nUltimate Wisdom!\n",
  "\n\n\n\n\n\n\nHe says:\nEven though the\nGreat Evil Lords\nhave been routed\nevil yet remains\nin Britannia.\n\n\n\n\n\nIf but one soul\ncould complete\nthe Quest of the\nAvatar, our\npeople would\nhave a new hope,\na new goal for\nlife.\n\nThere would be a\nshining example\nthat there is\nmore to life\nthan the endless\nstruggle for\npossessions\nand gold!\n",
  "He says:\nThe Ankh is the\nsymbol of one\nwho strives for\nVirtue.  Keep it\nwith thee at all\ntimes for by\nthis mark thou\nshalt be known!\n",
  "\n\n\n\n\n\nHe says:\nThe Great\nStygian Abyss\nis the darkest\npocket of evil\nremaining in\nBritannia!\n\n\n\n\n\n\nIt is said that\nin the deepest\nrecesses of the\nAbyss is the\nChamber of the\nCodex!\n\n\nIt is also said\nthat only one of\nhighest Virtue\nmay enter this\nChamber, one\nsuch as an\nAvatar!!!\n",
  "\n\n\n\n\n\nHe says:\nMondain is dead!\n",
  "\n\n\n\n\n\nHe says:\nMinax is dead!\n",
  "\n\n\n\n\n\nHe says:\nExodus is dead!\n",
  "\nHe says:\nThe Eight\nVirtues of the\nAvatar are:\nHonesty,\nCompassion,\nValor,\nJustice,\nSacrifice,\nHonor,\nSpirituality,\nand Humility!\n"
};

const char* help[8] = {
    "To survive in this hostile land thou must first know thyself!"
    " Seek ye to master thy weapons and thy magical ability!\n"
    "\nTake great care in these thy first travels in Britannia.\n"
    "\nUntil thou dost well know thyself, travel not far from the"
    " safety of the townes!\n",

    "Travel not the open lands alone. There are many worthy people"
    " in the diverse townes whom it would be wise to ask to Join"
    " thee!\n"
    "\nBuild thy party unto eight travellers, for only a true"
    " leader can win the Quest!\n",

    "Learn ye the paths of virtue. Seek to gain entry unto the"
    " eight shrines!\n"
    "\nFind ye the Runes, needed for entry into each shrine, and"
    " learn each chant or \"Mantra\" used to focus thy meditations.\n"
    "\nWithin the Shrines thou shalt learn of the deeds which show"
    " thy inner virtue or vice!\n"
    "\nChoose thy path wisely for all thy deeds of good and evil"
    " are remembered and can return to hinder thee!\n",

    "Visit the Seer Hawkwind often and use his wisdom to help thee"
    " prove thy virtue.\n"
    "\nWhen thou art ready, Hawkwind will advise thee to seek the"
    " Elevation unto partial Avatarhood in a virtue.\n"
    "\nSeek ye to become a partial Avatar in all eight virtues,"
    " for only then shalt thou be ready to seek the codex!\n",

    "Go ye now into the depths of the dungeons. Therein recover the"
    " 8 colored stones from the altar pedestals in the halls of the"
    " dungeons.\n"
    "\nFind the uses of these stones for they can help thee in the"
    " Abyss!\n",

    "Thou art doing very well indeed on the path to Avatarhood!"
    " Strive ye to achieve the Elevation in all eight virtues!\n",

    "Before thou dost enter the Abyss thou shalt need the Key of"
    " Three Parts, and the Word of Passage.\n"
    "\nThen might thou enter the Chamber of the Codex of Ultimate"
    " Wisdom!\n",

    "Thou dost now seem ready to make the final journey into the"
    " dark Abyss! Go only with a party of eight!\n"
    "\nGood Luck, and may the powers of good watch over thee on"
    " this thy most perilous endeavor!\n"
    "\nThe hearts and souls of all Britannia go with thee now."
    " Take care, my friend.\n"
};

void screenMessageN(const char* text, int len) {
    fwrite(text, 1, len, stdout);
}

#define TEXT_AREA_H 12

static void messageParts(/*AnyKeyController* anyKey,*/ const char* text) {
    const char* cp = text;
    int lines = 0;
    int len;

    while (*cp == '\n')
        ++cp;

    while (*cp) {
        if (cp[0] == '\n') {
            ++lines;
            if (lines == TEXT_AREA_H ||
                cp[1] == '\n' ||
                (lines >= TEXT_AREA_H-2 && cp[-1] == '!')) {
                // Print newline except if page is completely full.
                if (lines != TEXT_AREA_H)
                    ++cp;
                lines = 0;

                len = cp - text;
                screenMessageN(text, len);
                text += len;
                //anyKey->waitTimeout();
                printf("------");

                while (*cp == '\n')
                    ++cp;
                continue;
            }
        }
        ++cp;
    }
    screenMessageN(text, cp - text);
}

int main() {
    int i;
    for(i = 0; i < 24; ++i) {
        printf("\nTEST %d:\n", i);
        messageParts(response[i]);
        printf("\nWhat else?\n");
    }

    for(i = 0; i < 8; ++i) {
        printf("\nHELP %d:\n", i);
        messageParts(help[i]);
        printf("\nWhat else?\n");
    }
    return 0;
}
