//
//  TableViewSectionedDataSource.swift
//  RxDataSources
//
//  Created by Krunoslav Zaher on 6/15/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import Foundation
    import UIKit
    #if !RX_NO_MODULE
        import RxCocoa
    #endif
    import Differentiator

    open class TableViewSectionedDataSource<Section: SectionModelType>:
        NSObject,
        UITableViewDataSource,
        SectionedViewDataSourceType {
        public typealias Item = Section.Item

        public typealias ConfigureCell = (TableViewSectionedDataSource<Section>, UITableView, IndexPath, Item) -> UITableViewCell
        public typealias TitleForHeaderInSection = (TableViewSectionedDataSource<Section>, Int) -> String?
        public typealias TitleForFooterInSection = (TableViewSectionedDataSource<Section>, Int) -> String?
        public typealias CanEditRowAtIndexPath = (TableViewSectionedDataSource<Section>, IndexPath) -> Bool
        public typealias CanMoveRowAtIndexPath = (TableViewSectionedDataSource<Section>, IndexPath) -> Bool

        #if os(iOS)
            public typealias SectionIndexTitles = (TableViewSectionedDataSource<Section>) -> [String]?
            public typealias SectionForSectionIndexTitle = (TableViewSectionedDataSource<Section>, _ title: String, _ index: Int) -> Int
        #endif

        #if os(iOS)
            public init(
                configureCell: @escaping ConfigureCell,
                titleForHeaderInSection: @escaping TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false },
                sectionIndexTitles: @escaping SectionIndexTitles = { _ in nil },
                sectionForSectionIndexTitle: @escaping SectionForSectionIndexTitle = { _, _, index in index }
            ) {
                self.configureCell = configureCell
                self.titleForHeaderInSection = titleForHeaderInSection
                self.titleForFooterInSection = titleForFooterInSection
                self.canEditRowAtIndexPath = canEditRowAtIndexPath
                self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
                self.sectionIndexTitles = sectionIndexTitles
                self.sectionForSectionIndexTitle = sectionForSectionIndexTitle
            }

        #else
            public init(
                configureCell: @escaping ConfigureCell,
                titleForHeaderInSection: @escaping TitleForHeaderInSection = { _, _ in nil },
                titleForFooterInSection: @escaping TitleForFooterInSection = { _, _ in nil },
                canEditRowAtIndexPath: @escaping CanEditRowAtIndexPath = { _, _ in false },
                canMoveRowAtIndexPath: @escaping CanMoveRowAtIndexPath = { _, _ in false }
            ) {
                self.configureCell = configureCell
                self.titleForHeaderInSection = titleForHeaderInSection
                self.titleForFooterInSection = titleForFooterInSection
                self.canEditRowAtIndexPath = canEditRowAtIndexPath
                self.canMoveRowAtIndexPath = canMoveRowAtIndexPath
            }
        #endif

        #if DEBUG
            // If data source has already been bound, then mutating it
            // afterwards isn't something desired.
            // This simulates immutability after binding
            var _dataSourceBound: Bool = false

            private func ensureNotMutatedAfterBinding() {
                assert(!_dataSourceBound, "Data source is already bound. Please write this line before binding call (`bindTo`, `drive`). Data source must first be completely configured, and then bound after that, otherwise there could be runtime bugs, glitches, or partial malfunctions.")
            }

        #endif

        // This structure exists because model can be mutable
        // In that case current state value should be preserved.
        // The state that needs to be preserved is ordering of items in section
        // and their relationship with section.
        // If particular item is mutable, that is irrelevant for this logic to function
        // properly.
        public typealias SectionModelSnapshot = SectionModel<Section, Item>

        private var _sectionModels: [SectionModelSnapshot] = []

        open var sectionModels: [Section] {
            return _sectionModels.map { Section(original: $0.model, items: $0.items) }
        }

        open subscript(section: Int) -> Section {
            let sectionModel = _sectionModels[section]
            return Section(original: sectionModel.model, items: sectionModel.items)
        }

        open subscript(indexPath: IndexPath) -> Item {
            get {
                return _sectionModels[indexPath.section].items[indexPath.item]
            }
            set(item) {
                var section = _sectionModels[indexPath.section]
                section.items[indexPath.item] = item
                _sectionModels[indexPath.section] = section
            }
        }

        open func model(at indexPath: IndexPath) throws -> Any {
            return self[indexPath]
        }

        open func setSections(_ sections: [Section]) {
            _sectionModels = sections.map { SectionModelSnapshot(model: $0, items: $0.items) }
        }

        open var configureCell: ConfigureCell {
            didSet {
                #if DEBUG
                    ensureNotMutatedAfterBinding()
                #endif
            }
        }

        open var titleForHeaderInSection: TitleForHeaderInSection {
            didSet {
                #if DEBUG
                    ensureNotMutatedAfterBinding()
                #endif
            }
        }

        open var titleForFooterInSection: TitleForFooterInSection {
            didSet {
                #if DEBUG
                    ensureNotMutatedAfterBinding()
                #endif
            }
        }

        open var canEditRowAtIndexPath: CanEditRowAtIndexPath {
            didSet {
                #if DEBUG
                    ensureNotMutatedAfterBinding()
                #endif
            }
        }

        open var canMoveRowAtIndexPath: CanMoveRowAtIndexPath {
            didSet {
                #if DEBUG
                    ensureNotMutatedAfterBinding()
                #endif
            }
        }

        #if os(iOS)
            open var sectionIndexTitles: SectionIndexTitles {
                didSet {
                    #if DEBUG
                        ensureNotMutatedAfterBinding()
                    #endif
                }
            }

            open var sectionForSectionIndexTitle: SectionForSectionIndexTitle {
                didSet {
                    #if DEBUG
                        ensureNotMutatedAfterBinding()
                    #endif
                }
            }
        #endif

        // UITableViewDataSource

        open func numberOfSections(in _: UITableView) -> Int {
            return _sectionModels.count
        }

        open func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
            guard _sectionModels.count > section else { return 0 }
            return _sectionModels[section].items.count
        }

        open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            precondition(indexPath.item < _sectionModels[indexPath.section].items.count)

            return configureCell(self, tableView, indexPath, self[indexPath])
        }

        open func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
            return titleForHeaderInSection(self, section)
        }

        open func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
            return titleForFooterInSection(self, section)
        }

        open func tableView(_: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return canEditRowAtIndexPath(self, indexPath)
        }

        open func tableView(_: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return canMoveRowAtIndexPath(self, indexPath)
        }

        open func tableView(_: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            _sectionModels.moveFromSourceIndexPath(sourceIndexPath, destinationIndexPath: destinationIndexPath)
        }

        #if os(iOS)
            open func sectionIndexTitles(for _: UITableView) -> [String]? {
                return sectionIndexTitles(self)
            }

            open func tableView(_: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
                return sectionForSectionIndexTitle(self, title, index)
            }
        #endif
    }
#endif
