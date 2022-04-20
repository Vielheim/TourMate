//
//  PlansCalendarDayView.swift
//  TourMate
//
//  Created by Rayner Lim on 28/3/22.
//

import SwiftUI

struct PlansCalendarDayView: View {
    @ObservedObject var viewModel: PlansViewModel

    let date: Date
    let plans: [Plan]
    let dateFormatter: DateFormatter
    let hourHeight: Float

    let onSelected: ((Plan) -> Void)?

    @State var planIdToSize: [String: CGSize] = [:]
    @State var planIdToOffset: [String: CGSize] = [:]
    @State var minWidth: CGFloat = 0

    @State var draggingPlanId: String = ""
    @GestureState var draggingOffset = CGSize.zero

    private let viewModelFactory = ViewModelFactory()

    init(viewModel: PlansViewModel,
         date: Date,
         plans: [Plan] = [],
         onSelected: ((Plan) -> Void)? = nil,
         hourHeight: Float = 64) {

        self.viewModel = viewModel
        self.date = date
        self.plans = plans
        self.onSelected = onSelected
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeStyle = .short
        self.hourHeight = hourHeight
    }

    func getHourString(for hour: Int) -> String {
        if hour == 0 || hour == 24 {
            return "12 AM"
        } else if hour < 12 {
            return "\(hour) AM"
        } else if hour == 12 {
            return "12 PM"
        } else {
            return "\(hour - 12) PM"
        }
    }

    func getYPosition(for plan: Plan) -> (start: Float, end: Float) {
        let startDateComponents = Calendar
            .current
            .dateComponents(in: plan.startDateTime.timeZone, from: plan.startDateTime.date)
        let startDate = Calendar.current.date(from: DateComponents(year: startDateComponents.year,
                                                                   month: startDateComponents.month,
                                                                   day: startDateComponents.day))!
        let endDateComponents = Calendar
            .current
            .dateComponents(in: plan.endDateTime.timeZone, from: plan.endDateTime.date)
        let endDate = Calendar.current.date(from: DateComponents(year: endDateComponents.year,
                                                                 month: endDateComponents.month,
                                                                 day: endDateComponents.day))!
        var start: Float = 0
        var end: Float = 24 * hourHeight
        if startDate == date {
            start = (Float(startDateComponents.hour ?? 0) + Float(startDateComponents.minute ?? 0) / 60) * hourHeight
        }
        if endDate == date {
            end = (Float(endDateComponents.hour ?? 0) + Float(endDateComponents.minute ?? 0) / 60) * hourHeight
        }

        return (start: start, end: end)
    }

    func getHeight(for plan: Plan) -> Float {
        let yPosition = getYPosition(for: plan)
        return yPosition.end - yPosition.start
    }

    func calculateOffsets() {
        var planIdRect: [(planId: String, rect: CGRect)] = []

        // Get initial rects
        for plan in plans {
            let origin = CGPoint(x: CGFloat(0.0), y: CGFloat(getYPosition(for: plan).start))
            let size = planIdToSize[plan.id] ?? CGSize(width: 0, height: 0)
            let rect = CGRect(origin: origin, size: size)
            planIdRect.append((planId: plan.id, rect: rect))
        }

        // Set Y offset for first plan
        if !planIdRect.isEmpty {
            let firstPlanIdRect = planIdRect[0]
            planIdToOffset[firstPlanIdRect.planId] = CGSize(width: 0, height: firstPlanIdRect.rect.origin.y)
            minWidth = firstPlanIdRect.rect.width

            // Calculate and set X, Y offsets to not overlap
            for i in 1 ..< planIdRect.count {
                let currentPlanIdRect = planIdRect[i]
                let currentPlanId = currentPlanIdRect.planId
                let currentRect = currentPlanIdRect.rect

                for j in 0..<i {
                    let prevPlanIdRect = planIdRect[j]
                    let prevPlanId = prevPlanIdRect.planId
                    let prevRect = prevPlanIdRect.rect

                    // If Y position overlaps, offset to the right
                    let prevEndY = prevRect.origin.y + prevRect.size.height
                    let currentStartY = currentRect.origin.y
                    if currentStartY < prevEndY {
                        var prevEndX = prevRect.origin.x + prevRect.size.width + 6
                        if let offset = planIdToOffset[prevPlanId] {
                            prevEndX += offset.width
                        }
                        planIdToOffset[currentPlanId] = CGSize(width: prevEndX, height: currentStartY)
                        minWidth = max(minWidth, prevEndX + currentRect.width)
                    } else if planIdToOffset[currentPlanId] == nil {
                        planIdToOffset[currentPlanId] = CGSize(width: 0, height: currentStartY)
                    }
                }
            }
        }
    }

    func getOffset(for planId: String) -> CGSize {
        var totalOffset = CGSize(width: 0, height: 6)
        if let offset = planIdToOffset[planId] {
            totalOffset.width += offset.width
            totalOffset.height += offset.height
        }
        if planId == draggingPlanId {
            totalOffset.height += draggingOffset.height
        }
        return totalOffset
    }

    func handlePlanDragEnded(plan: Plan, offset: Float) async {
        let hoursOffset = offset / hourHeight
        let minutesOffset = Int(60 * hoursOffset)
        let originalStartDateTime = plan.startDateTime.date
        let originalEndDateTime = plan.endDateTime.date
        let newStartDateTime = Calendar.current.date(byAdding: .minute,
                                                     value: minutesOffset,
                                                     to: originalStartDateTime)!
        let newEndDateTime = Calendar.current.date(byAdding: .minute,
                                                   value: minutesOffset,
                                                   to: originalEndDateTime)!

        let tripStartDateTime = viewModel.tripStartDateTime
        let tripEndDateTime = viewModel.tripEndDateTime

        let editPlanViewModel = viewModelFactory
            .getEditPlanViewModel(plan: plan.copy(),
                                  lowerBoundDate: tripStartDateTime.date,
                                  upperBoundDate: tripEndDateTime.date)

        plan.startDateTime = DateTime(date: newStartDateTime, timeZone: tripStartDateTime.timeZone)
        plan.endDateTime = DateTime(date: newEndDateTime, timeZone: tripEndDateTime.timeZone)

        await editPlanViewModel.updatePlan(plan)
    }

    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0...24, id: \.self) { hour in
                        VStack {
                            Text(getHourString(for: hour))
                                .font(.caption)
                            Spacer()
                        }
                        .frame(height: CGFloat(hourHeight))
                    }
                }
                ZStack {
                    ScrollView(.horizontal) {
                        VStack(alignment: .leading, spacing: 0) {
                            ZStack(alignment: .topLeading) {
                                ForEach(plans, id: \.id) { plan in
                                    HStack {
                                        PlanBoxView(plansViewModel: viewModel,
                                                    plan: plan, date: date)
                                            .onTapGesture {
                                                if let onSelected = onSelected {
                                                    onSelected(plan)
                                                }
                                            }
                                            .gesture(
                                                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                                    .updating($draggingOffset) { value, state, _ in
                                                        state = value.translation
                                                    }
                                                    .onChanged { _ in
                                                        draggingPlanId = plan.id
                                                    }
                                                    .onEnded { gesture in
                                                        Task {
                                                            await handlePlanDragEnded(plan: plan, offset: Float(gesture.translation.height))
                                                            draggingPlanId = ""
                                                            calculateOffsets()
                                                        }
                                                    }
                                            )
                                            .frame(maxWidth: UIScreen.screenWidth / 3,
                                                   minHeight: CGFloat(getHeight(for: plan)),
                                                   alignment: .topLeading)
                                            .readSize { size in
                                                planIdToSize[plan.id] = size
                                                calculateOffsets()
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Color.primary.opacity(0.25))
                                            )
                                            .offset(getOffset(for: plan.id))
                                        Spacer()
                                    }
                                }
                            }
                            Spacer()
                        }
                        .frame(minWidth: minWidth)
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(0...24, id: \.self) { _ in
                            VStack(alignment: .leading, spacing: 0) {
                                Divider()
                                Spacer()
                            }
                            .frame(height: CGFloat(hourHeight))
                            .offset(y: 6)
                        }
                    }
                }
            }
            .padding()
        }
    }
}
