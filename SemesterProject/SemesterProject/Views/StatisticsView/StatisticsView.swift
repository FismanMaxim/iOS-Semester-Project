//
//  StatisticsViewController.swift
//  SemesterProject
//
//  Created by mfisman on 09.11.2025.
//

import UIKit

final class StatisticsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel: AppViewModel
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private enum Section: Int, CaseIterable {
        case subjects
        case totals
    }
    
    init(viewModel: AppViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Статистика"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .subjects: return "Общее время учебы по предметам"
        case .totals: return "Итого"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .subjects:
            return viewModel.subjects.isEmpty ? 1 : viewModel.totalsBySubject().count
        case .totals:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        configureCellAppearance(cell, for: indexPath)
        
        switch Section(rawValue: indexPath.section)! {
        case .subjects:
            if viewModel.subjects.isEmpty {
                cell.textLabel?.text = "Нет предметов"
                cell.detailTextLabel?.text = nil
                cell.selectionStyle = .none
            } else {
                let pair = viewModel.totalsBySubject()[indexPath.row]
                cell.textLabel?.text = pair.0.name
                cell.detailTextLabel?.text = formatDuration(pair.1)
                cell.detailTextLabel?.textColor = .secondaryLabel
            }
        case .totals:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Всего времени по предметам"
                let total = viewModel.sessions
                    .filter { $0.subjectID != nil }
                    .map { $0.duration }
                    .reduce(0, +)
                cell.detailTextLabel?.text = formatDuration(total)
            } else {
                cell.textLabel?.text = "Всего времени без предмета"
                let total = viewModel.sessions
                    .filter { $0.subjectID == nil }
                    .map { $0.duration }
                    .reduce(0, +)
                cell.detailTextLabel?.text = formatDuration(total)
            }
        }
        return cell
    }
    
    private func configureCellAppearance(_ cell: UITableViewCell, for indexPath: IndexPath) {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemBackground
        backgroundView.layer.cornerRadius = 10
        backgroundView.layer.masksToBounds = true
        
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowRadius = 2
        backgroundView.layer.shadowOpacity = 0.1
        
        cell.backgroundView = backgroundView
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.selectionStyle = .default
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .systemGray6
        selectedBackgroundView.layer.cornerRadius = 10
        selectedBackgroundView.layer.masksToBounds = true
        
        cell.selectedBackgroundView = selectedBackgroundView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundView?.frame = cell.bounds.insetBy(dx: 16, dy: 4)
        cell.selectedBackgroundView?.frame = cell.bounds.insetBy(dx: 16, dy: 4)
    }
    
    // MARK: - Helpers
    
    private func formatDuration(_ sec: TimeInterval) -> String {
        let total = Int(sec)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 {
            return String(format: "%dh %02dm", h, m)
        } else {
            return String(format: "%dm %02ds", m, s)
        }
    }
}
