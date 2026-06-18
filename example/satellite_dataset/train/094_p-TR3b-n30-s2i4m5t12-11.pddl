(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	spectrograph3 - mode
	spectrograph1 - mode
	image2 - mode
	thermograph0 - mode
	thermograph4 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation5 - direction
	Star7 - direction
	Star6 - direction
	GroundStation1 - direction
	Star10 - direction
	GroundStation4 - direction
	Star9 - direction
	GroundStation8 - direction
	Star11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 Star6)
	(supports instrument1 image2)
	(calibration_target instrument1 GroundStation1)
	(supports instrument2 spectrograph3)
	(supports instrument2 thermograph0)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star11)
	(supports instrument3 thermograph0)
	(supports instrument3 spectrograph1)
	(calibration_target instrument3 Star11)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 GroundStation4)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
)
(:goal (and
	(have_image Star12 image2)
	(have_image Phenomenon13 image2)
	(have_image Phenomenon14 image2)
	(have_image Planet15 thermograph4)
))

)
