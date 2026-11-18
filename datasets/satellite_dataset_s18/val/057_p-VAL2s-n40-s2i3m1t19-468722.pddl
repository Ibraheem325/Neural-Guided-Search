(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	image0 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	Star15 - direction
	Star16 - direction
	GroundStation17 - direction
	Star18 - direction
	GroundStation11 - direction
	Star1 - direction
	GroundStation6 - direction
	Star10 - direction
	GroundStation12 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Star24 - direction
	Planet25 - direction
	Star26 - direction
	Phenomenon27 - direction
	Phenomenon28 - direction
	Planet29 - direction
	Phenomenon30 - direction
	Star31 - direction
	Planet32 - direction
	Phenomenon33 - direction
	Phenomenon34 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation11)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation12)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet32)
)
(:goal (and
	(pointing satellite1 Planet29)
	(have_image Phenomenon19 image0)
	(have_image Planet20 image0)
	(have_image Planet21 image0)
	(have_image Phenomenon22 image0)
	(have_image Star23 image0)
	(have_image Star24 image0)
	(have_image Planet25 image0)
	(have_image Star26 image0)
	(have_image Phenomenon27 image0)
	(have_image Phenomenon28 image0)
	(have_image Planet29 image0)
	(have_image Phenomenon30 image0)
	(have_image Star31 image0)
	(have_image Planet32 image0)
	(have_image Phenomenon33 image0)
	(have_image Phenomenon34 image0)
))

)
