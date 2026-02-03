# Massive thanks go to...

- [Polished Crystal](https://github.com/Rangi42/polishedcrystal/commit/d171514171abdfcc640cf5e9ba7a5807e2cda30c#diff-a05a7db4f77fc57a038f317b7b49aaae23f37e3a212898b2c11510cf8535858cs) for the original `flag_array` code. This implementation is based on their approach and would never have been possible without their incredible work.
- The tutorial how to [add a new Mart](https://github.com/pret/pokecrystal/wiki/Add-a-new-Mart) which provided the basis for the new mart type where you can buy (but not sell) TM's.
- The tutorial that allows to [show move names for TM's](https://github.com/pret/pokecrystal/wiki/Show-move-names-for-TMs-and-HMs-when-receiving-or-buying) which is such a nice QOL change and was adapted to fit here as well.


## [Convert TMs/HMs from items to `flag_array`](https://github.com/xaerochill/pokecrystal/commit/f7ec248b6b8a91298e18ba1ffe525140a0ba4c11)
Converts TMs/HMs from inventory items to a flag array (`wTMsHMs`). Each TM/HM is now a single bit - owned or not owned. Adds constants, WRAM definitions, and core flag manipulation functions (`ReceiveTMHM`, `CheckTMHM`). Placeholder items are also added to keep the structure intact.

## [Add `GetTMHMName` for flag-based TM/HM names](https://github.com/xaerochill/pokecrystal/commit/755c1bc934fb69ba46363b3171581530d6cda268)
Adds `GetTMHMName` to generate "TM##" or "HM#" strings from flag numbers. Exports `TMHMMoves` table for cross-bank access which allows for the name of the move being shown when you buy or receive TM's or HM's.

## [Implement `MARTTYPE_TM_SHOP`](https://github.com/xaerochill/pokecrystal/commit/d64a3ee6bdcc11f371848cd40f4fd15f7d2d21e1)
Implements a dedicated TM shop that handles TM purchasing with flag checks instead of inventory. There is no option to sell TM's. Adds `PlaceMenuTMName` for shop menu display of the move names.

## [Add new macros to acquire TM's/HM's](https://github.com/xaerochill/pokecrystal/commit/8c03b1ac0541fa55a3a18267340bd5620e7c6444)
Adds `tmhmball` macro for placing TMs on maps and updates `FindItemInBallScript` to handle TM/HM pickups separately from regular items, setting flags instead of adding to inventory. Also adds `verbosegivetmhm` and related functions for maps where you receive a TM or HM from an NPC.

## [Update map scripts to use the new macros](https://github.com/xaerochill/pokecrystal/commit/6ffcfe612594635c1d548b4e0cfa300e68c30519)
Cleans up  all map scripts  to use the new flag-based TM/HM system instead of giving or receiving items.
