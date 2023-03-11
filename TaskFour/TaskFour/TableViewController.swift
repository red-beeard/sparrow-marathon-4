//
//  TableViewController.swift
//  TaskFour
//
//  Created by Alexander Nifontov on 11.03.2023.
//

import UIKit

final class TableViewController: UITableViewController {
	
	// MARK: - Types
	
	private typealias DiffableDataSource = UITableViewDiffableDataSource<Int, Int>
	private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Int>
	
	// MARK: - Properties
	
	private var dataSource: DiffableDataSource?
	private var values = Array(1...30)
	private var selectedValues: [Int] = []
	
	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.allowsMultipleSelection = true
		
		createDataSource()
		apply(animated: false)
	}
	
	// MARK: - Methods
	
	private func createDataSource() {
		dataSource = DiffableDataSource(tableView: tableView) { [weak self] tableView, indexPath, itemIdentifier in
			let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			let isSelected = self?.selectedValues.contains(itemIdentifier) ?? false
			
			var configuration = cell.defaultContentConfiguration()
			configuration.text = "\(itemIdentifier)"
			cell.contentConfiguration = configuration
			cell.accessoryType = isSelected ? .checkmark : .none
			
			return cell
		}
		tableView.dataSource = dataSource
	}
	
	private func apply(animated: Bool) {
		var snapshot = Snapshot()
		snapshot.appendSections([0])
		snapshot.appendItems(values, toSection: 0)
		dataSource?.apply(snapshot, animatingDifferences: animated)
	}
	
	// MARK: - Actions
	
	@IBAction func shuffleDataSource(_ sender: Any) {
		values.shuffle()
		apply(animated: true)
	}
}

// MARK: - UITableViewDelegate

extension TableViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		guard let cell = tableView.cellForRow(at: indexPath) else { return }
		let isSelected = cell.accessoryType == .checkmark
		cell.accessoryType = isSelected ? .none : .checkmark
		
		let value = values[indexPath.row]
		
		if isSelected == false {
			values.remove(at: indexPath.row)
			values.insert(value, at: 0)
			selectedValues.append(value)
			apply(animated: true)
		} else {
			selectedValues.removeAll { $0 == value }
		}
	}
}

