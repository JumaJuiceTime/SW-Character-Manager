# Item Data

## Spreadsheet Rules

Keep the first spreadsheet row as plain column names. Do not add quotation marks around headers or values; CSV quoting is only needed when a field contains commas, quotes, or line breaks. The exporter writes valid JavaScript object keys, including names such as `File name`, `Defense Rating`, and `Defese Bonus`.

Keep the existing header spelling unless the application is updated to use a renamed column. `Name` identifies a player-facing record, `Visible` must be `TRUE` for it to appear in the UI, `Prerequisite` should match another record's `Name` exactly, and `Cost` should contain a numeric value. Keep dice expressions such as `1d12+1` as text.

For armor, `Upgradeable Underlay` and `Upgradable Overlay` set the modification slots. Upgrade records use `Subtype` to identify a compatible slot, such as `Underlay`, `Overlay`, `Power Crystal`, or `Color Crystal`. Only visible upgrades that the character owns can be installed.

## Export Workflow

Keep `SW Item Database.xlsx` as the editable workbook. Export each worksheet as a UTF-8, comma-delimited CSV into this folder, using the existing filenames such as `SW Item Database - Armor.csv`. Then run `Build-Databases.ps1` from a PowerShell session that permits local scripts. It generates the JavaScript files consumed by the HTML. The page does not read the CSV files at runtime.

Optional worksheets may be exported as `Class.csv`, `Species.csv`, `Background.csv`, `Droid Parts.csv`, `Consumables.csv`, or `Implants.csv`. The exporter writes the corresponding JavaScript data files. Class, species, and background records are loaded into `window.appData`; their character-sheet controls still need to be connected to those schemas.

## Preparing Item Modifiers

Use an explicit modifier schema in upgrade sheets before assigning combat or core-stat effects. A useful starting point is `Target Type`, `Target Slot`, `Attack Bonus`, `Defense Bonus`, `Stat`, `Stat Bonus`, and `Prerequisite`. Keep the installed upgrade's own item record in inventory data; the character's installed-upgrade mapping should reference its stable item ID. That gives equipment calculations one unambiguous path to combine base item values and installed modifiers without parsing prose descriptions.

For lightsaber recoloring, add `Blade Color` to color-crystal upgrade rows and to each color-specific lightsaber weapon row. Use the same canonical value in both places, such as `Blue`, `Red`, or `Viridian`. Add `Appearance Group` to weapon rows to distinguish `Single`, `Short`, and `Double-Bladed` hilts. Keep each row's `File name` as the image for that weapon variant and keep the crystal's `File name` as its crystal icon. When rendering an equipped saber, the app can match the installed color crystal's `Blade Color` and the weapon's `Appearance Group` to select the corresponding weapon image. Avoid deriving color from display names or crystal icon filenames.