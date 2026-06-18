(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	satellite3 - satellite
	instrument6 - instrument
	image4 - mode
	infrared3 - mode
	thermograph1 - mode
	infrared2 - mode
	spectrograph0 - mode
	spectrograph6 - mode
	image5 - mode
	Star0 - direction
	Star2 - direction
	Star5 - direction
	Star7 - direction
	GroundStation8 - direction
	Star11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	GroundStation6 - direction
	GroundStation1 - direction
	GroundStation4 - direction
	GroundStation9 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation12)
	(supports instrument1 infrared2)
	(supports instrument1 spectrograph6)
	(supports instrument1 image4)
	(calibration_target instrument1 GroundStation13)
	(supports instrument2 infrared2)
	(supports instrument2 spectrograph0)
	(supports instrument2 thermograph1)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation13)
	(supports instrument3 spectrograph0)
	(supports instrument3 infrared2)
	(supports instrument3 image5)
	(calibration_target instrument3 GroundStation3)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation4)
	(supports instrument4 spectrograph6)
	(supports instrument4 infrared3)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 GroundStation4)
	(supports instrument5 spectrograph6)
	(supports instrument5 thermograph1)
	(supports instrument5 infrared3)
	(calibration_target instrument5 GroundStation1)
	(calibration_target instrument5 GroundStation4)
	(calibration_target instrument5 GroundStation6)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation12)
	(supports instrument6 spectrograph0)
	(supports instrument6 infrared3)
	(calibration_target instrument6 GroundStation9)
	(calibration_target instrument6 GroundStation4)
	(on_board instrument6 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star11)
)
(:goal (and
	(have_image Phenomenon14 image5)
	(have_image Phenomenon14 image4)
	(have_image Phenomenon15 spectrograph0)
	(have_image Phenomenon15 infrared3)
	(have_image Phenomenon16 spectrograph0)
	(have_image Phenomenon16 infrared2)
	(have_image Planet17 spectrograph0)
))

)
