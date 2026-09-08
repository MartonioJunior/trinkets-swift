# Trinkets

Trinkets is a framework that provides a base for implementing gameplay features (Resources, Inventory, Progression, etc.) through a common set of useful abstractions provided by these modules:

- `Collectables`: Uniquely-identified elements that can be obtained and/or tracked in the game. Useful for defining item types, in-game elements and encyclopedias.
- `Custom`: Values that can be transformed by applying and removing modifiers on top of it. Useful for attributes, buffs/debuffs, status effects, customization options, equipment and weapons.
- `Exchanges`: Transaction-based solution for in-game economy models. Useful for defining shops, trades, collection points, resource drainers, etc.
- `Flow`: A solution for defining transformations of state and allowing said transformations to be controlled and rescaled. Useful for counters, timers, calculating timing windows, creating sequences of state mapped over an axis.
- `Inventory`: Model for building in-game inventories with composition in mind. Useful for any type of item storage (inventories, chests, dispensers, storages), which can then be queried for information (e.g. item checks).
- `Notation`: Set of utilities to help with localization that is based on the context it is used in.
- `SI`: Default implementation of the `Units` architecture providing SI-based units.
- `Units`: A new implementation of Swift Foundation's Units and Measurements, focused on Composition and Generics.

## Architecture
(Coming soon)

## Examples
(Coming soon)

## Roadmap
- `Progression`: Model for defining the structure of progression in a game (leveling systems, checklist of requirements, goals, rewards, rule systems, turn-based systems).
- `Activities`: Composable activities and actions that are scopable (inspired by The Composable Architecture).
- `Matches`: Solution for participants, scoreboards and outcomes for use in contests and matches.
- `Quests`: Architecture for in-game quests and missions.
- `Tabletop`: Spatial components (inspired on tabletop and map design)

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
