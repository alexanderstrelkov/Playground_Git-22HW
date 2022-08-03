import Foundation

var stack = Storage<Chip>()
let chipCreation = ChipCreate(storage: stack)
let chipSoldering = ChipSolder(storage: stack)
chipCreation.start()
chipSoldering.start()



