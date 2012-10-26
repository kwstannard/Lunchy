require File.expand_path '../../../app/models/spot_picker', __FILE__
describe SpotPicker do
  let (:picker) { SpotPicker }
  describe "#pick" do
    let (:spot1) { double('1', last_went: Time.now) }
    let (:spot2) { double('2', last_went: Time.now) }
    let (:spots) { [spot1, spot2] }
    let (:users) { [double(favorite_spot: nil)] }

    context "equal spots" do
      it "can pick randomly between two spots" do
        @delta = delta_per_rep(spots, 10000)
        delta_is_between 0.05, -0.05
      end
    end

    context "spot2 has been gone to more recently than spot1" do
      it "picks spot1" do
        spot1.stub! last_went: (Time.now - 86400)
        picker.pick(spots, users).should be spot1
      end
    end

    context "spot 2 is a favorite of a user" do
      let (:users) { [double( favorite_spot: spot2)] }
      it "picks spot2" do
        picker.pick(spots, users).should be spot2
      end

      context "spot one hasn't been visited in a day" do
        it "picks spot 1" do
          spot1.stub! last_went: (Time.now - 86400)
          picker.pick(spots, users).should be spot1
        end
      end

      context "spot one hasn't been visited in 2 days and spot 2 in one day" do
        it "picks spot 2" do
          spot2.stub! last_went: (Time.now - 86400)
          spot1.stub! last_went: (Time.now - 172800)
          picker.pick(spots, users).should be spot2
        end
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
      results[picker.pick(objects, users)] += 1
    end
    (results[objects.first] - results[objects.last]).to_f / reps
  end

end
