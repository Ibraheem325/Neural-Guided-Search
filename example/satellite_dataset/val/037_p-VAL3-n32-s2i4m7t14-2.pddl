(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	image5 - mode
	thermograph1 - mode
	spectrograph0 - mode
	infrared3 - mode
	spectrograph6 - mode
	infrared2 - mode
	image4 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation4 - direction
	Star5 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	GroundStation10 - direction
	GroundStation6 - direction
	GroundStation3 - direction
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
	(supports instrument1 image5)
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
	(supports instrument3 infrared3)
	(calibration_target instrument3 GroundStation3)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation4)
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
