(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	thermograph1 - mode
	image2 - mode
	image3 - mode
	GroundStation0 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation14 - direction
	GroundStation17 - direction
	GroundStation18 - direction
	Star19 - direction
	GroundStation20 - direction
	GroundStation23 - direction
	Star24 - direction
	Star25 - direction
	Star26 - direction
	GroundStation27 - direction
	Star1 - direction
	GroundStation15 - direction
	Star21 - direction
	Star16 - direction
	Star6 - direction
	GroundStation13 - direction
	GroundStation22 - direction
	Star5 - direction
	Phenomenon28 - direction
)
(:init
	(supports instrument0 image3)
	(supports instrument0 image2)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation22)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 Star16)
	(calibration_target instrument0 Star21)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation15)
)
(:goal (and
	(pointing satellite0 Star19)
	(have_image Phenomenon28 infrared0)
))

)
