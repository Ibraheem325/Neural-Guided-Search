(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	thermograph2 - mode
	infrared3 - mode
	infrared5 - mode
	infrared10 - mode
	thermograph9 - mode
	image0 - mode
	infrared4 - mode
	infrared1 - mode
	image8 - mode
	image7 - mode
	image6 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star5 - direction
	Star6 - direction
	Star8 - direction
	Star9 - direction
	Star11 - direction
	Star14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star18 - direction
	Star20 - direction
	Star21 - direction
	Star22 - direction
	GroundStation27 - direction
	Star23 - direction
	Star7 - direction
	Star19 - direction
	Star10 - direction
	GroundStation25 - direction
	Star24 - direction
	GroundStation12 - direction
	GroundStation17 - direction
	Star4 - direction
	Star0 - direction
	Star26 - direction
	Star13 - direction
	Star28 - direction
	Star29 - direction
	Planet30 - direction
	Star31 - direction
)
(:init
	(supports instrument0 thermograph9)
	(supports instrument0 infrared3)
	(supports instrument0 image6)
	(supports instrument0 image7)
	(supports instrument0 image0)
	(supports instrument0 infrared10)
	(calibration_target instrument0 Star24)
	(calibration_target instrument0 GroundStation25)
	(calibration_target instrument0 Star26)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star19)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star23)
	(calibration_target instrument0 Star0)
	(supports instrument1 infrared1)
	(supports instrument1 image8)
	(supports instrument1 infrared4)
	(supports instrument1 infrared5)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 Star26)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation17)
	(calibration_target instrument1 GroundStation12)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(have_image Star28 image7)
	(have_image Star29 image7)
	(have_image Star29 image0)
	(have_image Planet30 thermograph2)
	(have_image Planet30 image8)
	(have_image Star31 image8)
	(have_image Star31 image0)
	(have_image Star31 infrared4)
))

)
