//
//  PlanView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct PlanView: View {
    @StateObject var planViewModel: PlanViewModel
    let commentsViewModel: CommentsViewModel
    let planUpvoteViewModel: PlanUpvoteViewModel
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    private let viewModelFactory: ViewModelFactory

    init(planViewModel: PlanViewModel) {
        self._planViewModel = StateObject(wrappedValue: planViewModel)
        self.viewModelFactory = ViewModelFactory()
        self.commentsViewModel = viewModelFactory.getCommentsViewModel(planViewModel: planViewModel)
        self.planUpvoteViewModel = viewModelFactory.getPlanUpvoteViewModel(planViewModel: planViewModel)
    }

    var body: some View {
        if planViewModel.hasError {
            Text("Error occurred")
        } else if planViewModel.isLoading {
            ProgressView()
        } else {
            VStack(alignment: .leading, spacing: 30.0) {
                // TODO: Show image

                PlanHeaderView(planName: planViewModel.nameDisplay,
                               planStatus: planViewModel.statusDisplay,
                               planOwner: planViewModel.planOwner,
                               creationDateDisplay: planViewModel.creationDateDisplay)

                PlanUpvoteView(viewModel: planUpvoteViewModel)

                TimingView(startDate: planViewModel.startDateTimeDisplay,
                           endDate: planViewModel.endDateTimeDisplay)

                LocationView(startLocation: planViewModel.startLocationDisplay,
                             endLocation: planViewModel.endLocationDisplay)

                InfoView(additionalInfo: planViewModel.additionalInfoDisplay)

                CommentsView(viewModel: commentsViewModel)

                Spacer() // Push everything to the top
            }
            .padding()
            .navigationBarTitle("") // Needed in order to display the nav back button. Best fix is to use .inline
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        EditPlanView(viewModel: viewModelFactory.getEditPlanViewModel(planViewModel: planViewModel))
                    }
                }
            }
            .task {
                await planViewModel.fetchPlanAndListen()
                await planViewModel.updatePlanOwner()
            }
            .onReceive(planViewModel.objectWillChange) {
                if planViewModel.isDeleted {
                    dismiss()
                }
            }
            .onDisappear(perform: { () in planViewModel.detachListener() })
        }
    }
}

// struct PlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlanView()
//    }
// }
