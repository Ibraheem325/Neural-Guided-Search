(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	satellite3 - satellite
	instrument4 - instrument
	satellite4 - satellite
	instrument5 - instrument
	instrument6 - instrument
	infrared2 - mode
	thermograph0 - mode
	spectrograph4 - mode
	thermograph1 - mode
	thermograph3 - mode
	Star2 - direction
	GroundStation4 - direction
	Star6 - direction
	GroundStation5 - direction
	GroundStation3 - direction
	Star0 - direction
	GroundStation1 - direction
	Planet7 - direction
	Star8 - direction
	Planet9 - direction
	Planet10 - direction
	Planet11 - direction
	Star12 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star0)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation1)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet11)
	(supports instrument3 thermograph0)
	(supports instrument3 thermograph3)
	(calibration_target instrument3 GroundStation5)
	(on_board instrument3 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation3)
	(supports instrument4 spectrograph4)
	(supports instrument4 thermograph3)
	(calibration_target instrument4 GroundStation1)
	(on_board instrument4 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation3)
	(supports instrument5 thermograph0)
	(supports instrument5 infrared2)
	(supports instrument5 spectrograph4)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 GroundStation3)
	(supports instrument6 thermograph0)
	(supports instrument6 thermograph3)
	(supports instrument6 infrared2)
	(calibration_target instrument6 GroundStation1)
	(on_board instrument5 satellite4)
	(on_board instrument6 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star12)
)
(:goal (and
	(pointing satellite1 Planet11)
	(pointing satellite2 Planet11)
	(pointing satellite4 Planet10)
	(have_image Planet7 spectrograph4)
	(have_image Star8 thermograph1)
	(have_image Planet9 thermograph1)
	(have_image Planet10 thermograph0)
	(have_image Planet11 spectrograph4)
	(have_image Star12 thermograph0)
))

)
