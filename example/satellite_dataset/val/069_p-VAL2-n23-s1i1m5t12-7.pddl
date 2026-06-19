(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared4 - mode
	spectrograph2 - mode
	image0 - mode
	thermograph1 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	GroundStation1 - direction
	GroundStation10 - direction
	GroundStation8 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Star14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 infrared4)
	(supports instrument0 thermograph1)
	(supports instrument0 image0)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon13)
)
(:goal (and
	(pointing satellite0 Phenomenon12)
	(have_image Phenomenon12 spectrograph2)
	(have_image Phenomenon13 infrared3)
	(have_image Star14 infrared3)
	(have_image Star15 spectrograph2)
))

)
