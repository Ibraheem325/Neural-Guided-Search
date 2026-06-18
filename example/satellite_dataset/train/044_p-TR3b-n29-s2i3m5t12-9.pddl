(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	spectrograph1 - mode
	infrared2 - mode
	thermograph4 - mode
	infrared0 - mode
	image3 - mode
	GroundStation1 - direction
	GroundStation5 - direction
	Star9 - direction
	GroundStation6 - direction
	Star10 - direction
	Star11 - direction
	Star0 - direction
	GroundStation7 - direction
	Star3 - direction
	Star8 - direction
	GroundStation2 - direction
	Star4 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 thermograph4)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 Star11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon13)
	(supports instrument1 image3)
	(supports instrument1 spectrograph1)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 Star10)
	(supports instrument2 image3)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation7)
	(supports instrument3 thermograph4)
	(supports instrument3 image3)
	(supports instrument3 infrared2)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star3)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
)
(:goal (and
	(pointing satellite0 Phenomenon15)
	(have_image Planet12 infrared2)
	(have_image Phenomenon13 spectrograph1)
	(have_image Phenomenon14 thermograph4)
	(have_image Phenomenon15 spectrograph1)
))

)
