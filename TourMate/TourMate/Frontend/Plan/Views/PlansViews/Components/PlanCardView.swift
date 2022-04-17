//
//  PlanCardView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

@MainActor
struct PlanCardView: View {

    @ObservedObject var plansViewModel: PlansViewModel
    @StateObject var commentsViewModel: CommentsViewModel
    @StateObject var planUpvoteViewModel: PlanUpvoteViewModel

    let plan: Plan
    let date: Date
    let displayIndex: Int?

    init(plansViewModel: PlansViewModel, plan: Plan, date: Date, index: Int? = nil) {
        self.plansViewModel = plansViewModel
        self.plan = plan
        self.date = date
        self.displayIndex = index

        let viewModelFactory = ViewModelFactory()

        let planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(plan: plan)
        self._planUpvoteViewModel = StateObject(wrappedValue: planUpvoteViewModel)

        let commentsViewModel = viewModelFactory.getCommentsViewModel(plan: plan)
        self._commentsViewModel = StateObject(wrappedValue: commentsViewModel)
    }

    var body: some View {
        HStack(alignment: .center) {
            if let index = displayIndex {
                ZStack {
                    Image(systemName: "circle.fill")
                        .font(.title)
                        .foregroundColor(plan.status == .confirmed ? .green : .red)
                    Text(String(index))
                        .foregroundColor(.white)
                }
                .padding([.leading])
            }

            VStack(alignment: .leading) {
                HStack(spacing: 10.0) {
                    Text(DateUtil.shortDurationDesc(from: plan.startDateTime, to: plan.endDateTime, on: date))
                        .font(.caption)

                    PlanStatusView(status: plan.status)

                }

                Text(plan.name)
                    .font(.headline)
            }
            .padding()

            Spacer()

            VStack {
                Spacer()

                PlanUpvoteView(viewModel: planUpvoteViewModel, displayName: false)
                    .frame(maxWidth: UIScreen.screenWidth / 3)

                Spacer()

            }

            VStack(spacing: 5.0) {
                Spacer()

                HStack(spacing: 5.0) {
                    Image(systemName: "text.bubble.fill")

                    Text(String(commentsViewModel.commentCount))
                }

                Text("(v\(String(plan.versionNumber)))")
                    .font(.caption)

                Spacer()
            }
            .padding([.horizontal])

        }
        .contentShape(Rectangle())
        .onAppear {
            plansViewModel.attachDelegate(planId: plan.id, delegate: planUpvoteViewModel)

            Task {
                await commentsViewModel.fetchCommentsAndListen()
            }
        }
        .onDisappear {
            plansViewModel.detachDelegate(planId: plan.id)
            commentsViewModel.detachListener()
        }
    }
}
