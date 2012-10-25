require File.expand_path '../../../app/models/spot_picker', __FILE__
describe SpotPicker do
  let (:picker) { SpotPicker }
  describe "#pick" do
    let (:spot1) { double('1', name: double, last_went: Time.now, fans: []) }
    let (:spot2) { double('2', name: double, last_went: Time.now, fans: []) }
    let (:spots) { [spot1, spot2] }

    context "equal spots" do
      it "can pick randomly between two spots" do
        @delta = delta_per_rep(spots, 10000)
        delta_is_between 0.05, -0.05
      end
    end

    context "spot2 has been gone to more recently than spot1" do
      it "picks spot1" do
        spot1.stub! last_went: (Time.now - 50000)
        picker.pick(spots).should be spot1
      end
    end

    context "spot 2 is a favorite of a user" do
      it " picks spot2" do
        spot2.stub! fans: [double]
        picker.pick(spots).should be spot2
      end
    end

    context "spot 2 has a fan and spot one hasn't been visited in a day" do
      it "picks spot 2" do
        spot1.stub! last_went: (Time.now - 86400)
        spot2.stub! fans: [double]
        picker.pick(spots).should be spot2
      end
    end

    context "spot 2 has a fan and spot one hasn't been visited in 2 days" do
      it "picks spot 1" do
        spot1.stub! last_went: (Time.now - 172800)
        spot2.stub! fans: [double]
        picker.pick(spots).should be spot1
      end
    end
  end

  def delta_is_between x, y
    @delta.should < x
    @delta.should > y
  end

  def delta_per_rep(objects, reps)
    results = Hash.new(0)
    reps.times do
      results[picker.pick(objects)] += 1
    end
    (results[objects.first] - results[objects.last]).to_f / reps
  end

end
