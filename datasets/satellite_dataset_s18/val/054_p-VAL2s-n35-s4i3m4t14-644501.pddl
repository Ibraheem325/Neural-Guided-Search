(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	instrument6 - instrument
	infrared0 - mode
	thermograph2 - mode
	spectrograph1 - mode
	image3 - mode
	GroundStation1 - direction
	Star2 - direction
	GroundStation5 - direction
	Star7 - direction
	Star6 - direction
	Star12 - direction
	GroundStation11 - direction
	Star10 - direction
	GroundStation13 - direction
	Star9 - direction
	Star8 - direction
	Star0 - direction
	GroundStation4 - direction
	GroundStation3 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Phenomenon17 - direction
	Phenomenon18 - direction
	Star19 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation4)
	(supports instrument1 image3)
	(calibration_target instrument1 Star12)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 Star6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
	(supports instrument2 spectrograph1)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 Star10)
	(supports instrument3 thermograph2)
	(supports instrument3 infrared0)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 GroundStation13)
	(calibration_target instrument3 Star10)
	(calibration_target instrument3 Star0)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
	(supports instrument4 image3)
	(supports instrument4 spectrograph1)
	(supports instrument4 thermograph2)
	(calibration_target instrument4 Star8)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 GroundStation13)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star6)
	(supports instrument5 infrared0)
	(supports instrument5 thermograph2)
	(supports instrument5 image3)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 Star0)
	(calibration_target instrument5 GroundStation3)
	(supports instrument6 spectrograph1)
	(supports instrument6 image3)
	(supports instrument6 infrared0)
	(calibration_target instrument6 GroundStation3)
	(on_board instrument5 satellite3)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon15)
)
(:goal (and
	(pointing satellite2 GroundStation4)
	(pointing satellite3 Star8)
	(have_image Phenomenon14 infrared0)
	(have_image Phenomenon15 thermograph2)
	(have_image Planet16 thermograph2)
	(have_image Phenomenon17 infrared0)
	(have_image Phenomenon18 spectrograph1)
	(have_image Star19 infrared0)
))

)
