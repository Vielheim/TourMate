//
//  PlansMapDayView.swift
//  TourMate
//
//  Created by Rayner Lim on 11/4/22.
//

import SwiftUI
import MapKit

struct PlansMapDayView: View {
    @ObservedObject var viewModel: PlansViewModel
    private let viewModelFactory = ViewModelFactory()

    let date: Date
    let idPlans: [IdentifiablePlan]
    let onSelected: ((Plan) -> Void)?

    @State private var selectedItem = 0
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.334_900,
                                           longitude: -122.009_020),
            latitudinalMeters: 750,
            longitudinalMeters: 750
        )

    init(viewModel: PlansViewModel,
         date: Date,
         idPlans: [IdentifiablePlan] = [],
         onSelected: ((Plan) -> Void)? = nil) {
        self.viewModel = viewModel
        self.date = date
        self.idPlans = idPlans
        self.onSelected = onSelected
    }

    func getLocations(from plans: [IdentifiablePlan]) -> [IdentifiableLocation] {
        plans.flatMap { idPlan in
            idPlan.plan.locations.map { location in
                IdentifiableLocation(
                    id: idPlan.id,
                    coordinate: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    ),
                    status: idPlan.plan.status
                )
            }
        }
    }

    func handleSelectedItemChanged(_ value: Int) {
        guard idPlans.indices.contains(value) else {
            return
        }
        let plan = idPlans[value].plan
        guard let location = plan.locations.first else {
            return
        }
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: location.latitude,
                longitude: location.longitude
            ),
            span: region.span
        )
    }

    func handlePlansChanged(_ idPlans: [IdentifiablePlan]) {
        let coordinates = getLocations(from: idPlans).map { $0.coordinate }
        let midpoint = getGeographicMidpoint(betweenCoordinates: coordinates)
        let maxDistance = getMaximumDistance(betweenCoordinates: coordinates)
        region = MKCoordinateRegion(
            center: midpoint,
            latitudinalMeters: maxDistance * 4,
            longitudinalMeters: maxDistance * 4
        )
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, annotationItems: getLocations(from: idPlans)) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    ZStack {
                        Image(systemName: "circle.fill")
                            .font(.title)
                            .foregroundColor(location.status == .confirmed ? .green : .red)
                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(location.status == .confirmed ? .green : .red)
                            .offset(x: 0, y: 16)
                        Text(String(location.id + 1))
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        withAnimation {
                            selectedItem = location.id
                            handleSelectedItemChanged(location.id)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            VStack {
                HStack {
                    Spacer()
                    Button("Re-center") {
                        withAnimation {
                            handlePlansChanged(idPlans)
                        }
                    }
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.primary.opacity(0.2), radius: 2)
                    )
                }
                .padding([.horizontal])

                TabView(selection: $selectedItem) {
                    ForEach(idPlans, id: \.id) { idPlan in
                        PlanCardView(plansViewModel: viewModel,
                                     plan: idPlan.plan,
                                     date: date,
                                     index: idPlan.id + 1)
                        .onTapGesture(perform: {
                            if let onSelected = onSelected {
                                onSelected(idPlan.plan)
                            }
                        })
                        .buttonStyle(PlainButtonStyle())
                        .background(RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(.systemBackground))
                                        .shadow(color: Color.primary.opacity(0.25), radius: 4)
                        )
                        .padding()
                        .tag(idPlan.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 100.0)
                .onChange(of: selectedItem) { value in
                    withAnimation {
                        handleSelectedItemChanged(value)
                    }
                }
            }
        }
        .onChange(of: idPlans) { newPlans in
            handlePlansChanged(newPlans)
        }
    }
}
